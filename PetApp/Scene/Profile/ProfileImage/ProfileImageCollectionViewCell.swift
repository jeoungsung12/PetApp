//
//  ProfileImageCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private let size = ((UIScreen.main.bounds.width) - (12 * 5)) / 4
    lazy var profileButton = CustomProfileButton(size, false)
    private(set) var profileImage: String?
    
    override var isSelected: Bool {
        didSet {
            self.updateProfile()
        }
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(profileButton)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        profileButton.containerView.isHidden = true
        profileButton.alpha = (isSelected ? 1 : 0.5)
        profileButton.isUserInteractionEnabled = false
        profileButton.profileImage.setBorder(isSelected, size / 2)
    }
}

extension ProfileImageCollectionViewCell {
    
    func configure(_ image: String) {
        profileImage = image
        profileButton.profileImage.image = UIImage(named: image)
    }
    
    private func updateProfile() {
        profileButton.alpha = (isSelected ? 1 : 0.5)
        profileButton.profileImage.setBorder(isSelected, size / 2)
    }
    
}
