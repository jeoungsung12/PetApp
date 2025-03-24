//
//  HomeViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class HomeViewController: BaseViewController {
    private let loadingIndicator = UIActivityIndicatorView()
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func setBinding() {
        let input = HomeViewModel.Input(
            
        )
        let output = viewModel.transform(input)
        loadingIndicator.startAnimating()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection> { dataSource, collectionView, indexPath, item in
            
            switch HomeSectionType.allCases[indexPath.section] {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCell.id, for: indexPath) as? HomeHeaderCell else { return UICollectionViewCell() }
                return cell
                
            case .middle:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMiddleCell.id, for: indexPath) as? HomeMiddleCell else { return UICollectionViewCell() }
                cell.configure(item.data)
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
            
            headerView.configure(dataSource.sectionModels[indexPath.section].title)
            
            return headerView
        }
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(HomeItem.self))
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, selected in
                //TODO: Coordinator
                let vm = DetailViewModel(model: selected.1.data)
                let vc = DetailViewController(viewModel: vm)
                switch HomeSectionType.allCases[selected.0.section] {
                case .header,
                        .middleAds:
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .middle,
                        .footer:
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .middleBtn:
                    //TODO: MapView
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        let result = output.homeResult
        
        result
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, _ in
                owner.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [collectionView, loadingIndicator].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        setNavigation()
        view.backgroundColor = .customWhite
        loadingIndicator.style = .medium
        loadingIndicator.color = .customLightGray
        configureCollectionView()
    }
}

extension HomeViewController {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .customWhite
        collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: HomeHeaderCell.id)
        collectionView.register(HomeMiddleCell.self, forCellWithReuseIdentifier: HomeMiddleCell.id)
        collectionView.register(HomeFooterCell.self, forCellWithReuseIdentifier: HomeFooterCell.id)
        collectionView.register(HomeEtcCell.self, forCellWithReuseIdentifier: HomeEtcCell.id)
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
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.2))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
            
        case .middle, .footer:
            groupSize = type == .middle
            ? NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(250))
            : NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            
            group = type == .middle
            ? NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            : NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = type == .middle ?
            NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6) :
            NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = type == .middle ? .continuous : .none
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute((type == .middle) ? 20 : 50)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
        case .middleBtn:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: -24, leading: 12, bottom: 24, trailing: 12)
            
        case .middleAds:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 48, trailing: 12)
        }
        
        return section
    }
}
