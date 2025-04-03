//
//  DetailFooterCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SnapKit
import MapKit

final class DetailFooterCell: BaseTableViewCell, ReusableIdentifier {
    private let titleLabel = UILabel()
    private let shelterLabel = UILabel()
    private let numberLabel = UILabel()
    private let addressLabel = UILabel()
    
    override func configureView() {
        titleLabel.font = .largeBold
        titleLabel.text = "보호 장소 📍"
        
        shelterLabel.font = .mediumBold
        numberLabel.font = .mediumSemibold
        addressLabel.font = .mediumRegular
        addressLabel.numberOfLines = 2
        
        titleLabel.textColor = .customBlack
        shelterLabel.textColor = .customBlack
        numberLabel.textColor = .customLightGray
        addressLabel.textColor = .customBlack
        [titleLabel, shelterLabel, numberLabel, addressLabel].forEach {
            $0.textAlignment = .left
        }
    }
    
    override func configureHierarchy() {
        [titleLabel, shelterLabel, numberLabel, addressLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        shelterLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(shelterLabel.snp.bottom).offset(8)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(numberLabel.snp.bottom).offset(8)
        }
    }
    
    func configure(_ entity: HomeEntity) {
        shelterLabel.text = entity.shelter.name
        numberLabel.text = entity.shelter.number
        addressLabel.text = entity.shelter.address
    }
    
}
