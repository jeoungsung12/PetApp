//
//  SponsorViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SponsorViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let regularSponsorButton = UIButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private let viewModel = SponsorViewModel()
    private var disposeBag = DisposeBag()
    
    override func setBinding() {
        let input = SponsorViewModel.Input()
        let output = viewModel.transform(input)
        
        output.sponsorResult
            .drive(collectionView.rx.items(cellIdentifier: SponsorCollectionViewCell.id, cellType: SponsorCollectionViewCell.self)) { index, item, cell in
                cell.configure(item)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .customWhite
        scrollView.backgroundColor = .customWhite
        scrollView.showsVerticalScrollIndicator = false
        
        titleLabel.text = "후원하기 🍚🏠"
        titleLabel.font = .headLine
        titleLabel.textColor = .customBlack
        
        subTitleLabel.text = "멀리서도 도움이 될 수 있어요!"
        subTitleLabel.font = .mediumBold
        subTitleLabel.textColor = .customLightGray
        
        descriptionLabel.text = "본 서비스는 사용자 편의를 위해 보호소 후원을 위한 간편 이동만을 지원하며, 후원금의 전달 및 사용에 대한 책임을 지지 않습니다."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .mediumRegular
        descriptionLabel.textColor = .customBlack
        
        regularSponsorButton.setTitle("직접후원", for: .normal)
        regularSponsorButton.backgroundColor = .point
        regularSponsorButton.setTitleColor(.white, for: .normal)
        regularSponsorButton.layer.cornerRadius = 8
        regularSponsorButton.titleLabel?.font = .mediumBold
        
        configureCollectionView()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleLabel, subTitleLabel, descriptionLabel, regularSponsorButton, collectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(36)
        }
        
        regularSponsorButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(regularSponsorButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(400)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension SponsorViewController {
    private func configureCollectionView() {
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .customWhite
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SponsorCollectionViewCell.self, forCellWithReuseIdentifier: SponsorCollectionViewCell.id)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 16
        let spacing: CGFloat = 8
        let availableWidth = UIScreen.main.bounds.width - (padding * 2) - (spacing * 2)
        let itemWidth = availableWidth / 3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        return layout
    }
}
