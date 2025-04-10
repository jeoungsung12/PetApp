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
        imageView.contentMode = .scaleAspectFill
    }
    
    override func configureView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.tintColor = .customLightGray
        imageView.backgroundColor = .systemGray5
        imageView.layer.borderWidth = 0.3
        imageView.layer.borderColor = UIColor.customLightGray.cgColor
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
            imageView.snSetImage(with: url) { [weak self] result in
                switch result {
                case .success(let image):
                    print("이미지 로드 성공 \(image)")
                case .failure(let error):
                    print("이미지 로드 에러 \(error), \(url)")
                    self?.imageView.image = .noImage
                    self?.imageView.contentMode = .scaleAspectFit
                }
            }
//            imageView.kf.setImage(with: url)
        }
    }
}
