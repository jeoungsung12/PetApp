//
//  ChatHeaderCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SNKit
import Kingfisher
import SnapKit

final class ChatHeaderCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
        thumbImageView.contentMode = .scaleAspectFill
    }
    
    override func configureView() {
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.layer.borderWidth = 2
        thumbImageView.layer.borderColor = UIColor.point.cgColor
        thumbImageView.layer.cornerRadius = self.contentView.frame.width / 2
        thumbImageView.tintColor = .customLightGray
        thumbImageView.backgroundColor = .systemGray5
        thumbImageView.layer.borderWidth = 0.3
        thumbImageView.layer.borderColor = UIColor.customLightGray.cgColor
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(thumbImageView)
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(self.contentView.frame.width)
            make.center.equalToSuperview()
        }
    }
    
    func configure(_ image: String) {
        if let url = URL(string: image) {
            thumbImageView.snSetImage(
                with: url,
                storageOption: .hybrid,
                processingOption: .downsample(CGSize(width: 100, height: 100))
            ) { [weak self] result in
                switch result {
                case .success(let image):
                    print("이미지 로드 성공 \(image)")
                case .failure(let error):
                    print("이미지 로드 에러 \(error), \(url)")
                    self?.thumbImageView.image = .noImage
                    self?.thumbImageView.contentMode = .scaleAspectFit
                }
            }
//            thumbImageView.kf.setImage(with: url)
        }
    }
    
}
