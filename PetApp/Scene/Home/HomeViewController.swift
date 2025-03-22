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
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-12)
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0)
            
        case .middle:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(250))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12)
            
        case .footer:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12)
        }
        
        return section
    }
}
