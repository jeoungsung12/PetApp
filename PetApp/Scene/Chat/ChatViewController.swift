//
//  ChatViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ChatViewController: BaseViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private let chatImageView = UIImageView()
    
    private let viewModel = ChatViewModel()
    private lazy var input = ChatViewModel.Input(
        loadTrigger: Observable.just(()),
        reloadRealm: PublishRelay()
    )
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.reloadRealm.accept(())
    }
    
    override func setBinding() {
        let output = viewModel.transform(input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection> { [weak self] dataSource, collectionView, indexPath, item in
            switch ChatSectionType.allCases[indexPath.section] {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatHeaderCell.id, for: indexPath) as? ChatHeaderCell else { return UICollectionViewCell() }
                cell.configure(item.data?.animal.thumbImage ?? "")
                return cell
                
            case .middle:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMiddleCell.id, for: indexPath) as? ChatMiddleCell else { return UICollectionViewCell() }
                return cell
                
            case .footer:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatFooterCell.id, for: indexPath) as? ChatFooterCell else { return UICollectionViewCell() }
                self?.chatImageView.isHidden = (item.data != nil)
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
            
            headerView.configure(dataSource.sectionModels[indexPath.section].title, true)
            
            return headerView
        }
        
        let result = output.homeResult
        
        result
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        result
            .drive(with: self) { owner, sections in
                if let section = sections.last {
                    owner.chatImageView.isHidden = !section.items.isEmpty
                }
            }
            .disposed(by: disposeBag)
        
        output.errorResult
            .drive(with: self) { owner, error in
                let errorVM = ErrorViewModel(notiType: .player)
                let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
                errorVC.modalPresentationStyle = .fullScreen
                owner.present(errorVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(HomeItem.self))
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, selected in
                if let data = selected.1.data {
                    let vm = ChatDetailViewModel(entity: data)
                    let vc = ChatDetailViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = ListViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        setNavigation(logo: true)
        view.backgroundColor = .customWhite
        
        chatImageView.contentMode = .scaleAspectFit
        chatImageView.image = UIImage(named: "chatBackDrop")
        
        collectionView.backgroundColor = .customWhite
        collectionView.register(ChatHeaderCell.self, forCellWithReuseIdentifier: ChatHeaderCell.id)
        collectionView.register(ChatMiddleCell.self, forCellWithReuseIdentifier: ChatMiddleCell.id)
        collectionView.register(ChatFooterCell.self, forCellWithReuseIdentifier: ChatFooterCell.id)
    }
    
    override func configureHierarchy() {
        [collectionView, chatImageView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        chatImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}

extension ChatViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createSectionLayout(ChatSectionType.allCases[sectionIndex])
        }
        return layout
    }
    
    private func createSectionLayout(_ type: ChatSectionType) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize
        let group: NSCollectionLayoutGroup
        let section: NSCollectionLayoutSection
        
        switch type {
        case .middle:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 48, trailing: 24)
            
        case .header, .footer:
            groupSize = (type == .header) ?
            NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(120)) :
            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            
            
            group = type == .header
            ? NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            : NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = type == .header ?
            NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12) :
            NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = type == .header ? .continuous : .none
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute((type == .header) ? 50 : 20)
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
