//
//  PhotoViewController.swift
//  PetApp
//
//  Created by 정성윤 on 4/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhotoViewController: BaseViewController, UICollectionViewDelegateFlowLayout {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private let viewModel = PhotoViewModel()
    private var disposeBag = DisposeBag()
    private var itemSizes: [CGSize] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.showLoading()
        collectionView.delegate = self
    }
    
    override func setBinding() {
        let input = PhotoViewModel.Input(
            loadTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        input.loadTrigger.accept(viewModel.page)
        LoadingIndicator.showLoading()
        
        output.homeResult.asDriver()
            .drive(with: self) { owner, entities in
                owner.itemSizes = Array(repeating: CGSize.zero, count: entities.count)
            }
            .disposed(by: disposeBag)
        
        output.homeResult.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: PhotoCell.id, cellType: PhotoCell.self)) { [weak self] row, element, cell in
                guard let self = self else { return }
                if row >= self.itemSizes.count {
                    self.itemSizes.append(CGSize.zero)
                }
                
                let width = (self.collectionView.frame.width - 28) / 2
                self.itemSizes[row] = CGSize(width: width, height: 200)
                
                cell.configure(element.animal.fullImage) { aspectRatio in
                    let width = (self.collectionView.frame.width - 28) / 2
                    if row < self.itemSizes.count {
                        self.itemSizes[row] = CGSize(width: width, height: width * aspectRatio)
                        self.collectionView.collectionViewLayout.invalidateLayout()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.homeResult.asDriver()
            .drive(with: self) { owner, _ in
                LoadingIndicator.hideLoading()
            }
            .disposed(by: disposeBag)
        
        output.errorResult
            .drive(with: self) { owner, error in
                let errorVM = ErrorViewModel(notiType: .player)
                let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
                errorVC.modalPresentationStyle = .overCurrentContext
                owner.present(errorVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(HomeEntity.self)
            .bind(with: self) { owner, entity in
                let vm = DetailViewModel(model: entity)
                let vc = DetailViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .bind(with: self) { owner, IndexPaths in
                if let lastIndex = IndexPaths.last.map({ $0.row }),
                   (output.homeResult.value.count - 2) < lastIndex
                {
                    LoadingIndicator.showLoading()
                    input.loadTrigger.accept(owner.viewModel.page + 1)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.cancelPrefetchingForItems
            .bind(with: self) { owner, indexPaths in
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(4)
            make.verticalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = MasonryLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < itemSizes.count, itemSizes[indexPath.row] != .zero {
            return itemSizes[indexPath.row]
        }
        let width = (collectionView.frame.width - 28) / 2
        return CGSize(width: width, height: 200)
    }
}
