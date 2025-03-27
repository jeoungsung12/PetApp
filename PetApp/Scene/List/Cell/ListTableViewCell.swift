//
//  ListTableViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import Kingfisher
import SnapKit

final class ListTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let thumbImageview = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusLabel = UILabel()
    
    override func configureView() {
        thumbImageview.clipsToBounds = true
        thumbImageview.contentMode = .scaleAspectFill
        thumbImageview.layer.cornerRadius = 10
        thumbImageview.backgroundColor = .customLightGray
        
        titleLabel.textColor = .customLightGray
        titleLabel.font = .mediumRegular
        
        subTitleLabel.textColor = .customBlack
        subTitleLabel.font = .largeBold
        subTitleLabel.numberOfLines = 2
        
        descriptionLabel.textColor = .customBlack
        descriptionLabel.font = .mediumRegular
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        
        [titleLabel, subTitleLabel].forEach {
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        statusLabel.clipsToBounds = true
        statusLabel.font = .mediumBold
        statusLabel.layer.cornerRadius = 5
        statusLabel.textColor = .customWhite
        statusLabel.backgroundColor = .black.withAlphaComponent(0.5)
        statusLabel.textAlignment = .center
    }
    
    override func configureHierarchy() {
        [thumbImageview, statusLabel, titleLabel, subTitleLabel, descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageview.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(25)
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(thumbImageview.snp.top)
            make.leading.greaterThanOrEqualTo(thumbImageview.snp.trailing).offset(12)
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
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    func configure(_ model: HomeEntity?) {
        guard let model = model else { return }
        statusLabel.text = model.animal.state
        titleLabel.text = model.shelter.name
        subTitleLabel.text = model.animal.name
        descriptionLabel.text = model.animal.description
        
        if let url = URL(string: model.animal.fullImage) {
            thumbImageview.kf.setImage(with: url)
        }
    }
    
}
