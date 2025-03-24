//
//  HomeMiddleCell.swift
//  Moving
//
//  Created by 조우현 on 3/21/25.
//

import UIKit
import Kingfisher
import SnapKit

final class HomeMiddleCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageview = UIImageView()
    private let descriptionLabel = UILabel()
    private let shelterLabel = UILabel()
    private let hashTagLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = true
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
        
        shelterLabel.textColor = .customBlack
        shelterLabel.font = .mediumBold
        
        hashTagLabel.textColor = .customLightGray
        hashTagLabel.font = .mediumRegular
        
        descriptionLabel.font = .headLine
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
        statusLabel.layer.cornerRadius = 10
        statusLabel.textColor = .customWhite
        statusLabel.backgroundColor = .point
        statusLabel.textAlignment = .center
        statusLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    override func configureHierarchy() {
        [thumbImageview, statusLabel, descriptionLabel, shelterLabel, hashTagLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.5)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImageview.snp.top)
            make.trailing.equalTo(thumbImageview.snp.trailing)
            make.width.equalTo(50)
            make.height.equalTo(25)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(thumbImageview.snp.bottom).inset(12)
        }
        
        shelterLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(thumbImageview.snp.bottom).offset(8)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(shelterLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    func configure(_ model: HomeEntity?) {
        guard let model = model else { return }
        statusLabel.text = model.animal.state
        shelterLabel.text = model.shelter.name
        hashTagLabel.text = model.animal.description
        descriptionLabel.text = model.animal.name + "\n" + model.animal.age + model.animal.weight
        if let url = URL(string: model.animal.fullImage) {
            thumbImageview.kf.setImage(with: url)
        }
    }
    
}
