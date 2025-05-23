//
//  HomeViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
final class HomeViewController: BaseViewController {
    private let viewModel: HomeViewModel
    private let locationButton = LocationButton()
    private let disposeBag = DisposeBag()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    weak var coordinator: HomeCoordinator?
    private let input = HomeViewModel.Input(
        loadTrigger: PublishRelay<Void>()
    )
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.showLoading()
    }
    
    override func setBinding() {
        let output = viewModel.transform(input)
        input.loadTrigger.accept(())
        LoadingIndicator.showLoading()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection> { dataSource, collectionView, indexPath, item in
            switch HomeSectionType.allCases[indexPath.section] {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCell.id, for: indexPath) as? HomeHeaderCell else { return UICollectionViewCell() }
                cell.categoryView.delegate = self
                return cell
                
            case .middle:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMiddleCell.id, for: indexPath) as? HomeMiddleCell else { return UICollectionViewCell() }
                cell.configure(item.data)
                return cell
                
            case .middlePhoto:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePosterCell.id, for: indexPath) as? HomePosterCell else { return UICollectionViewCell() }
                cell.configure(with: item.data?.animal.fullImage)
                return cell
                
            case .footer:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFooterCell.id, for: indexPath) as? HomeFooterCell else { return UICollectionViewCell() }
                cell.configure(item.data)
                return cell
                
            case .middleBtn:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeEtcCell.id, for: indexPath) as? HomeEtcCell else { return UICollectionViewCell() }
                cell.configure(.map)
                return cell
                
            case .middleAds:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeEtcCell.id, for: indexPath) as? HomeEtcCell else { return UICollectionViewCell() }
                cell.configure(.ads)
                return cell
            }
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            
            collectionView.register(ReusableHeaderView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: ReusableHeaderView.id)
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ReusableHeaderView.id,
                for: indexPath) as? ReusableHeaderView else {
                return UICollectionReusableView()
            }
            
            headerView.delegate = self
            headerView.configure(dataSource.sectionModels[indexPath.section].title, type: HomeSectionType.allCases[indexPath.section])
            
            return headerView
        }
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(HomeItem.self))
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, selected in
                if let data = selected.1.data {
                    switch HomeSectionType.allCases[selected.0.section] {
                    case .middle,
                            .middlePhoto,
                            .footer:
                        owner.coordinator?.showDetail(with: data)
                    default:
                        break
                    }
                } else {
                    switch HomeSectionType.allCases[selected.0.section] {
                    case .middleBtn:
                        owner.coordinator?.showMap(mapType: .shelter)
                    default:
                        break
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .bind(with: self) { owner, _ in
                LoadingIndicator.showLoading()
            }
            .disposed(by: disposeBag)
        
        let result = output.homeResult
        
        result
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, _ in
                LoadingIndicator.hideLoading()
            }
            .disposed(by: disposeBag)
        
        output.errorResult
            .drive(with: self) { owner, error in
                owner.coordinator?.showError(error: error)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.bottom.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.setNavigation(logo: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationButton)
        view.backgroundColor = .customWhite
        configureCollectionView()
        coordinator?.errorDelegate = self
    }
    
    deinit {
        print(#function, self)
    }
}

extension HomeViewController: MoreBtnDelegate, CategoryDelegate, ErrorDelegate {
    
    func moreBtnTapped(_ type: HomeSectionType) {
        switch type {
        case .middlePhoto:
            self.coordinator?.showPhoto()
        default:
            self.coordinator?.showList()
        }
    }
    
    func didTapCategory(_ type: CategoryType) {
        switch type {
        case .shelter:
            self.coordinator?.showMap(mapType: .shelter)
        case .hospital:
            self.coordinator?.showMap(mapType: .hospital)
        case .heart:
            self.coordinator?.showLike()
        case .sponsor:
            self.coordinator?.showSponsor()
        }
    }
    
    func reloadNetwork(type: ErrorSenderType) {
        input.loadTrigger.accept(())
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .customWhite
        collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: HomeHeaderCell.id)
        collectionView.register(HomeMiddleCell.self, forCellWithReuseIdentifier: HomeMiddleCell.id)
        collectionView.register(HomeFooterCell.self, forCellWithReuseIdentifier: HomeFooterCell.id)
        collectionView.register(HomeEtcCell.self, forCellWithReuseIdentifier: HomeEtcCell.id)
        collectionView.register(HomePosterCell.self, forCellWithReuseIdentifier: HomePosterCell.id)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createSectionLayout(HomeSectionType.allCases[sectionIndex])
        }
        return layout
    }
    
    private func createSectionLayout(_ type: HomeSectionType) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize
        let group: NSCollectionLayoutGroup
        let section: NSCollectionLayoutSection
        
        switch type {
        case .header:
            let collectionWidth = collectionView.frame.width
            let totalHeight = collectionWidth + 90
            
            groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(totalHeight)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
            
        case .middle:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(250))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
        case .middlePhoto:
            groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.33)
            )
            let subitemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0/3.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let subitem = NSCollectionLayoutItem(layoutSize: subitemSize)
            subitem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [subitem, subitem, subitem])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(20)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
        case .middleBtn:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: -24, leading: 0, bottom: 24, trailing: 0)
            
        case .middleAds:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(130))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 24, trailing: 0)
            
        case .footer:
            groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(200)
            )
            let subitemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            let subitem = NSCollectionLayoutItem(layoutSize: subitemSize)
            subitem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [subitem, subitem])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
        }
        
        return section
    }
}
