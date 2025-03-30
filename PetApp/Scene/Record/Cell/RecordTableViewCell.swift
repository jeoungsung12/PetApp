//
//  RecordTableViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class RecordTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let iconImageView = UIImageView()
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()
    private let removeButton = UIButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private let pageControl = UIPageControl()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let viewModel = RecordTableViewModel()
    private lazy var input = RecordTableViewModel.Input(
        imageTrigger: PublishRelay(),
        removeTrigger: PublishRelay()
    )
    private var disposeBag = DisposeBag()
    
    weak var delegate: RemoveDelegate?
    private var entity: RecordRealmEntity?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        [locationLabel, dateLabel, titleLabel, descriptionLabel].forEach {
            $0.text = nil
        }
    }
    
    override func setBinding() {
        let output = viewModel.transform(input)
        
        removeButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let entity = owner.entity else { return }
                //TODO: Alert
                owner.input.removeTrigger.accept(entity)
            }
            .disposed(by: disposeBag)
        
        let imageResult = output.imageResult
        
        imageResult
            .drive(collectionView.rx.items(cellIdentifier: PosterCell.id, cellType: PosterCell.self)) { items, element, cell in
                if let image = UIImage(contentsOfFile: element) {
                    cell.configure(with: image)
                }
            }
            .disposed(by: disposeBag)
        
        imageResult
            .drive(with: self) { owner, images in
                if let image = images.first {
                    owner.iconImageView.image = UIImage(contentsOfFile: image)
                }
                owner.pageControl.numberOfPages = images.count
            }
            .disposed(by: disposeBag)
        
        output.removeResult
            .drive(with: self) { owner, valid in
                if valid {
                    owner.delegate?.remove()
                } else {
                    owner.makeToast("삭제 실패!", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll
            .bind(with: self, onNext: { owner, _ in
                let page = Int(owner.collectionView.contentOffset.x / owner.collectionView.frame.width)
                owner.pageControl.currentPage = page
            })
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.backgroundColor = .customLightGray
        iconImageView.layer.cornerRadius = 20
        
        locationLabel.textColor = .customBlack
        locationLabel.font = .mediumBold
        dateLabel.textColor = .customLightGray
        dateLabel.font = .mediumSemibold
        
        removeButton.tintColor = .point
        removeButton.imageView?.contentMode = .scaleAspectFit
        removeButton.setImage(UIImage(systemName: "eraser.fill"), for: .normal)
        
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .systemGray5
        
        titleLabel.textColor = .customBlack
        titleLabel.numberOfLines = 0
        titleLabel.font = .largeBold
        
        descriptionLabel.textColor = .customBlack
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .mediumRegular
        
        configureCollectionView()
    }
    
    override func configureHierarchy() {
        [
            iconImageView,
            locationLabel,
            dateLabel,
            removeButton,
            collectionView,
            pageControl,
            titleLabel,
            descriptionLabel
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(40)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(locationLabel.snp.bottom).offset(4)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(42)
            make.bottom.equalTo(iconImageView.snp.bottom)
        }
        
        removeButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(pageControl.snp.bottom).offset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(_ entity: RecordRealmEntity) {
        self.entity = entity
        
        locationLabel.text = entity.location
        dateLabel.text = entity.date
        
        titleLabel.text = entity.title
        descriptionLabel.text = entity.subTitle
        
        input.imageTrigger.accept(Array(entity.imagePaths))
        
        pageControl.numberOfPages = entity.imagePaths.count
        pageControl.currentPage = 0
    }
    
}

extension RecordTableViewCell {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    
    private func configureCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .customWhite
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.id)
    }
}
