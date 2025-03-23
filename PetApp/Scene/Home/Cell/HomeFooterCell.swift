//
//  HomeFooterCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/22/25.
//

import UIKit
import Kingfisher
import SnapKit

final class HomeFooterCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageview = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = true
    }
    
    override func configureView() {
        thumbImageview.clipsToBounds = true
        thumbImageview.contentMode = .scaleAspectFill
        thumbImageview.layer.cornerRadius = 60
        thumbImageview.backgroundColor = .customLightGray
        
        titleLabel.textColor = .customBlack
        titleLabel.font = .mediumBold
        
        subTitleLabel.textColor = .customLightGray
        subTitleLabel.font = .mediumRegular
        
        [titleLabel, subTitleLabel].forEach {
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
    }
    
    override func configureHierarchy() {
        [thumbImageview, titleLabel, subTitleLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageview.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.top.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(thumbImageview.snp.top)
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
        }
    }
    
    func configure(_ model: HomeEntity) {
        titleLabel.text = model.shelter
        subTitleLabel.text = model.hashTag
        
        //TODO: 임시
        thumbImageview.image = UIImage(named: model.thumbImage)
//        if let url = URL(string: model.thumbImage) {
//            thumbImageview.kf.setImage(with: url)
//        }
    }
    
}
