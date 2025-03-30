//
//  RecordTableViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import UIKit
import SnapKit

final class RecordTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let iconImageView = UIImageView()
    private let locationLabel = UILabel()
    private let addressLabel = UILabel()
    private let removeButton = UIButton()
    private let collectionView = UICollectionView()
    private let pageControl = UIPageControl()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func setBinding() {
        
    }
    
    override func configureView() {
        
    }
    
    override func configureHierarchy() {
        [
            iconImageView,
            locationLabel,
            addressLabel,
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
            make.size.equalTo(30)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(40)
        }
        
        addressLabel.snp.makeConstraints { make in
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
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.frame.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(pageControl.snp.bottom).offset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(_ entity: RecordRealmEntity) {
        
    }
    
}
