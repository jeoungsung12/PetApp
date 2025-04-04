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
    }
    
    override func setBinding() {
        let input = PhotoViewModel.Input(
            loadTrigger: PublishRelay()
        )
        let output = viewModel.transform(input)
        input.loadTrigger.accept(viewModel.page)
        LoadingIndicator.showLoading()
        
        let result = output.homeResult.asDriver()
        
        result
            .drive(collectionView.rx.items(cellIdentifier: PhotoCell.id, cellType: PhotoCell.self)) { [weak self] row, element, cell in
                guard let self = self else { return }
                cell.configure(element.animal.fullImage)
                
                if let image = cell.imageView.image {
                    let aspectRatio = image.size.height / image.size.width
                    let width = (self.collectionView.frame.width - 30) / 2
                    let height = width * aspectRatio
                    self.itemSizes.append(CGSize(width: width, height: height))
                } else {
                    let width = (self.collectionView.frame.width - 30) / 2
                    self.itemSizes.append(CGSize(width: width, height: 200))
                }
            }
            .disposed(by: disposeBag)
        
        result
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
        
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < itemSizes.count {
            return itemSizes[indexPath.item]
        }
        let width = (collectionView.frame.width - 30) / 2
        return CGSize(width: width, height: 200)
    }
}
