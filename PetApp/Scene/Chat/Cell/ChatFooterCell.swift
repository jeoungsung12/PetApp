//
//  ChatFooterCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SNKit
import Kingfisher
import SnapKit

final class ChatFooterCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let shelterLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
        thumbImageView.contentMode = .scaleAspectFill
    }
    
    override func configureView() {
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.layer.cornerRadius = 25
        thumbImageView.tintColor = .customLightGray
        thumbImageView.backgroundColor = .systemGray5
        thumbImageView.layer.borderWidth = 0.3
        thumbImageView.layer.borderColor = UIColor.customLightGray.cgColor
        
        titleLabel.textColor = .customBlack
        titleLabel.font = .largeBold
        
        descriptionLabel.textColor = .customBlack
        descriptionLabel.font = .mediumRegular
        
        shelterLabel.textColor = .customLightGray
        shelterLabel.font = .mediumSemibold
        shelterLabel.textAlignment = .right
    }
    
    override func configureHierarchy() {
        [thumbImageView, titleLabel, descriptionLabel, shelterLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.top)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        
        shelterLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(4)
            make.bottom.trailing.equalToSuperview().inset(12)
        }
        
    }
    
    func configure(_ entity: HomeEntity?) {
        guard let entity = entity else { return }
        titleLabel.text = entity.animal.name
        descriptionLabel.text = "안녕하세요! 저에 대해 알고 싶으신가요? 편하게 질문해 주세요! 🐾"
        shelterLabel.text = entity.shelter.name
        
        if let url = URL(string: entity.animal.thumbImage) {
            thumbImageView.snSetImage(
                with: url,
                storageOption: .hybrid,
                processingOption: .downsample(CGSize(width: 50, height: 50))
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
