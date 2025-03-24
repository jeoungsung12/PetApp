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
    
    func configure(_ entity: HomeEntity) {
        shelterLabel.text = entity.shelter.name
        numberLabel.text = entity.shelter.number
        addressLabel.text = entity.shelter.address
        
        
        if let latitude = Double(entity.shelter.lat),
           let longitude = Double(entity.shelter.lon) {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = entity.shelter.name
            mapView.addAnnotation(annotation)
        }
    }
    
}
