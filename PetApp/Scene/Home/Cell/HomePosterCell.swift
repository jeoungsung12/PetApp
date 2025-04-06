//
//  HomePosterCell.swift
//  PetApp
//
//  Created by 정성윤 on 4/3/25.
//

import UIKit
import SNKit
import Kingfisher
import SnapKit

final class HomePosterCell: BaseCollectionViewCell, ReusableIdentifier {
    private let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func configureView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 5
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with image: String?) {
        if let url = URL(string: image ?? "") {
            imageView.snSetImage(with: url)
//            imageView.kf.setImage(with: url)
        }
    }
}
