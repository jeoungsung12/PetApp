//
//  HomeMiddleCell.swift
//  Moving
//
//  Created by 조우현 on 3/21/25.
//

import UIKit
import SNKit
import SnapKit

final class HomeMiddleCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageview = UIImageView()
    private let descriptionLabel = UILabel()
    private let shelterLabel = UILabel()
    private let hashTagLabel = UILabel()
    private let statusLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageview.image = nil
        [descriptionLabel, shelterLabel, hashTagLabel].forEach {
            $0.text = nil
        }
    }
    
    override func configureView() {
        thumbImageview.clipsToBounds = true
        thumbImageview.contentMode = .scaleAspectFill
        thumbImageview.layer.cornerRadius = 10
        thumbImageview.backgroundColor = .customLightGray
        
        shelterLabel.textColor = .customLightGray
        shelterLabel.font = .mediumBold
        
        hashTagLabel.textColor = .customBlack
        hashTagLabel.font = .mediumRegular
        
        dateLabel.textColor = .systemRed
        dateLabel.font = .mediumRegular
        dateLabel.textAlignment = .center
        
        descriptionLabel.font = .mediumBold
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .customWhite
        descriptionLabel.layer.shadowOpacity = 0.5
        descriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        descriptionLabel.layer.shadowColor = UIColor.customBlack.cgColor
        
        [shelterLabel, hashTagLabel].forEach {
            $0.textAlignment = .left
        }
        
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
            shelterLabel,
            hashTagLabel,
            statusLabel,
            dateLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(thumbImageview.snp.bottom).inset(8)
            make.horizontalEdges.equalTo(thumbImageview.snp.horizontalEdges).inset(8)
        }
        
        shelterLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(thumbImageview.snp.bottom).offset(8)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(shelterLabel.snp.bottom).offset(8)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(hashTagLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(25)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.top)
            make.bottom.equalTo(statusLabel.snp.bottom)
            make.leading.equalTo(statusLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(_ model: HomeEntity?) {
        guard let model = model else { return }
        statusLabel.text = model.animal.state
        shelterLabel.text = model.shelter.name
        hashTagLabel.text = model.animal.description
        dateLabel.text = "공고마감 \(model.shelter.endDate.toDate())일전!"
        descriptionLabel.text = model.animal.name + "\n" + model.animal.age + model.animal.weight
        if let url = URL(string: model.animal.fullImage) {
            thumbImageview.snSetImage(
                with: url,
                storageOption: .memory,
                processingOption: .downsample(CGSize(width: 150, height: 150))
            )
        }
    }
    
}
