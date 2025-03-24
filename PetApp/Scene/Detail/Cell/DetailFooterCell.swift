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
    private let mapView = MKMapView()
    
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
        
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 10
        
        [titleLabel, shelterLabel, numberLabel, addressLabel].forEach {
            $0.textAlignment = .left
        }
    }
    
    override func configureHierarchy() {
        [titleLabel, shelterLabel, numberLabel, addressLabel, mapView].forEach {
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
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(numberLabel.snp.bottom).offset(8)
        }
        
        mapView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(addressLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(64)
        }
    }
    
    func configure() {
        shelterLabel.text = "평택시유기동물보호소"
        numberLabel.text = "031-8024-3849"
        addressLabel.text = "경기도 평택시 진위면 야막길 108-86 (진위면), 경기도 평택시 진위면 야막리 85-4번지"
    }
    
}
