//
//  PhotoCell.swift
//  PetApp
//
//  Created by 정성윤 on 4/5/25.
//

import UIKit
import Kingfisher
import SNKit
import SnapKit

final class PhotoCell: BaseCollectionViewCell, ReusableIdentifier {
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    override func configureView() {
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        descriptionLabel.font = .largeBold
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .customWhite
        descriptionLabel.layer.shadowOpacity = 0.5
        descriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        descriptionLabel.layer.shadowColor = UIColor.customBlack.cgColor
    }
    
    override func configureHierarchy() {
        [imageView, descriptionLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(_ model: HomeEntity, completion: ((CGFloat) -> Void)? = nil) {
        guard let url = URL(string: model.animal.fullImage) else {
            completion?(1.0)
            return
        }
        descriptionLabel.text = "\(model.animal.name)\n\(model.animal.age)-\(model.animal.weight)"
        imageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                let aspectRatio = value.image.size.height / value.image.size.width
                completion?(aspectRatio)
                self.layoutIfNeeded()
            case .failure(let error):
                print("이미지 로드 실패: \(error)")
                completion?(1.0)
            }
        }
//        imageView.snSetImage(
//            with: url,
//            storageOption: .hybrid,
//            processingOption: .downsample(CGSize(width: 180, height: 180))
//        ) { result in
//            switch result {
//            case .success(let value):
//                let aspectRatio = value.size.height / value.size.width
//                completion?(aspectRatio)
//                self.layoutIfNeeded()
//            case .failure(let error):
//                print("이미지 로드 실패: \(error)")
//                completion?(1.0)
//            }
//        }
    }
}
