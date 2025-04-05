//
//  DetailFooterCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SnapKit
import MapKit
import RxSwift
import RxCocoa

final class DetailFooterCell: BaseTableViewCell, ReusableIdentifier {
    private let titleLabel = UILabel()
    private let shelterLabel = UILabel()
    private let numberLabel = UILabel()
    private let addressLabel = UILabel()
    private let phoneButton = UIButton()
    private let mapButton = UIButton()
    
    private var shelterNumber: String?
    private var shelterAddress: String?
    private var disposeBag = DisposeBag()
    
    override func setBinding() {
        phoneButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let number = owner.shelterNumber, !number.isEmpty else { return }
                let cleanedNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                if let url = URL(string: "tel://\(cleanedNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            .disposed(by: disposeBag)
        
        mapButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let address = owner.shelterAddress, !address.isEmpty else { return }
                let mapItem = MKMapItem()
                mapItem.name = address
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
            .disposed(by: disposeBag)
    }
    
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
        
        phoneButton.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        phoneButton.tintColor = .systemGreen
        
        mapButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
        mapButton.tintColor = .systemBrown
    }
    
    override func configureHierarchy() {
        [
            titleLabel,
            shelterLabel,
            numberLabel,
            addressLabel,
            phoneButton,
            mapButton
        ].forEach {
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
        
        phoneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(mapButton.snp.leading).offset(-24)
            make.size.equalTo(30)
        }
        
        mapButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(30)
        }
    }
    
    func configure(_ entity: HomeEntity) {
        shelterLabel.text = entity.shelter.name
        numberLabel.text = entity.shelter.number
        addressLabel.text = entity.shelter.address
        shelterNumber = entity.shelter.number
        shelterAddress = entity.shelter.address
    }
    
}
