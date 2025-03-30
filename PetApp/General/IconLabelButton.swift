//
//  IconLabelView.swift
//  PetApp
//
//  Created by 정성윤 on 3/23/25.
//

import UIKit
import SnapKit

final class IconLabelButton: BaseButton {
    private let iconImageView = UIImageView()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        
        iconImageView.contentMode = .scaleAspectFit
        
        subTitleLabel.font = .largeBold
        subTitleLabel.textAlignment = .center
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
            make.centerX.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    func configure(image: UIImage?, title: String, color: UIColor = .customLightGray) {
        self.layer.borderColor = color.cgColor
        subTitleLabel.textColor = color
        iconImageView.tintColor = color
        
        subTitleLabel.text = title
        iconImageView.image = image
    }
}
