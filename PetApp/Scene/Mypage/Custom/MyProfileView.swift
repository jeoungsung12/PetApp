//
//  MainProfileView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MyProfileView: BaseView {
    private let profileImage = CustomProfileButton(120, true)
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        [profileImage, nameLabel].forEach({
            self.addSubview($0)
        })
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        nameLabel.snp.makeConstraints { make in            make.top.equalTo(profileImage.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
        
        profileImage.containerView.isHidden = true
        profileImage.isUserInteractionEnabled = false
        
        nameLabel.textColor = .customBlack
        nameLabel.textAlignment = .center
        nameLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    func configure(_ userInfo: UserInfo) {
        nameLabel.text = userInfo.name
        profileImage.profileImage.image = UIImage(named: userInfo.image)
    }
    
}
