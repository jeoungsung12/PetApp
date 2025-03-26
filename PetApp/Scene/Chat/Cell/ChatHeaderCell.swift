//
//  ChatHeaderCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import Kingfisher
import SnapKit

final class ChatHeaderCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func configureView() {
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.layer.borderWidth = 2
        thumbImageView.layer.borderColor = UIColor.point.cgColor
        thumbImageView.layer.cornerRadius = 50
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(thumbImageView)
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    func configure(_ image: String) {
        if let url = URL(string: image) {
            thumbImageView.kf.setImage(with: url)
        }
    }
    
}
