//
//  CustomCalloutView.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import SnapKit

class CustomCalloutView: BaseView {
    private let numLabel = UILabel()
    private let addressLabel = UILabel()
    private let loadLabel = UILabel()
    private let numberLabel = UILabel()
    
    override func configureView() {
        numLabel.font = .largeBold
        numLabel.textColor = .customBlack
        numLabel.numberOfLines = 0
        
        addressLabel.font = .mediumSemibold
        addressLabel.textColor = .darkGray
        addressLabel.numberOfLines = 0
        
        loadLabel.font = .mediumSemibold
        loadLabel.textColor = .darkGray
        loadLabel.numberOfLines = 0
        
        numberLabel.font = .smallSemibold
        numberLabel.textColor = .point
        numberLabel.numberOfLines = 0
    }
    
    override func configureHierarchy() {
        [numLabel, addressLabel, loadLabel, numberLabel].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        numLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        loadLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(loadLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with entity: MapEntity) {
        numLabel.text = entity.numAddress
        addressLabel.text = entity.address
        numberLabel.text = entity.number
    }
}
