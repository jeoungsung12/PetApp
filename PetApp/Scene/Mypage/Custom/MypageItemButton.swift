//
//  MypageItemButton.swift
//  PetApp
//
//  Created by 정성윤 on 3/29/25.
//

import UIKit
import SnapKit

final class MypageItemButton: BaseButton {
    private let logoImageView = UIImageView()
    private let subTitleLabel = UILabel()
    
    private let type: MyPageCategoryType
    init(type: MyPageCategoryType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    override func configureView() {
        [logoImageView, subTitleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureHierarchy() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .customLightGray
        logoImageView.image = UIImage(systemName: type.image)
        
        subTitleLabel.tintColor = .customLightGray
        subTitleLabel.font = .mediumSemibold
        subTitleLabel.text = type.rawValue
        subTitleLabel.numberOfLines = 2
        subTitleLabel.textAlignment = .center
    }
    
    override func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalToSuperview().offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }
}
