//
//  HomeFooterCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/22/25.
//

import UIKit
import SNKit
import Kingfisher
import SnapKit

final class HomeFooterCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageview = UIImageView()
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageview.image = nil
    }
    
    override func configureView() {
        thumbImageview.clipsToBounds = true
        thumbImageview.contentMode = .scaleAspectFill
        thumbImageview.layer.cornerRadius = 10
        thumbImageview.backgroundColor = .customLightGray
        
        titleLabel.textColor = .customLightGray
        titleLabel.font = .mediumRegular
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        dateLabel.textColor = .systemRed
        dateLabel.font = .mediumRegular
        
        descriptionLabel.font = .mediumBold
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .customWhite
        descriptionLabel.layer.shadowOpacity = 0.5
        descriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        descriptionLabel.layer.shadowColor = UIColor.customBlack.cgColor
        
        statusLabel.clipsToBounds = true
        statusLabel.font = .mediumBold
        statusLabel.layer.cornerRadius = 5
        statusLabel.textColor = .customWhite
        statusLabel.backgroundColor = .point.withAlphaComponent(0.8)
        statusLabel.textAlignment = .center
    }
    
    override func configureHierarchy() {
        [
            thumbImageview,
            descriptionLabel,
            statusLabel,
            titleLabel,
            dateLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(thumbImageview.snp.bottom).inset(8)
            make.horizontalEdges.equalTo(thumbImageview.snp.horizontalEdges).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(thumbImageview.snp.bottom).offset(12)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.equalTo(50)
            make.height.equalTo(25)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    func configure(_ model: HomeEntity?) {
        guard let model = model else { return }
        statusLabel.text = model.animal.state
        titleLabel.text = model.shelter.name
        dateLabel.text = "공고마감 \(model.shelter.endDate.toDate())일전!"
        descriptionLabel.text = model.animal.name + "\n" + model.animal.age + model.animal.weight
        
        if let url = URL(string: model.animal.fullImage) {
//            thumbImageview.snSetImage(
//                with: url,
//                storageOption: .memory,
//                processingOption: .downsample(CGSize(width: 120, height: 120))
//            )
            thumbImageview.kf.setImage(with: url)
        }
    }
    
}
