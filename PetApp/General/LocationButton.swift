//
//  LocationButton.swift
//  PetApp
//
//  Created by 정성윤 on 4/7/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LocationButton: BaseButton {
    private let iconImageView = UIImageView()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        iconImageView.contentMode = .scaleAspectFit
        
        subTitleLabel.font = .mediumBold
        subTitleLabel.textAlignment = .right
        subTitleLabel.textAlignment = .center
        
        
        subTitleLabel.textColor = .customLightGray
        iconImageView.tintColor = .systemRed.withAlphaComponent(0.8)
    }
    
    override func configureHierarchy() {
        [subTitleLabel, iconImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(subTitleLabel.snp.leading).offset(-8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    func configure(image: UIImage?, title: String) {
        subTitleLabel.text = title
        iconImageView.image = image
    }
}
