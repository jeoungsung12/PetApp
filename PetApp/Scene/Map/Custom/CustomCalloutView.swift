//
//  CustomCalloutView.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CustomCalloutView: BaseView {
    private let numLabel = UILabel()
    private let addressLabel = UILabel()
    private let loadLabel = UILabel()
    private let numberBtn = UIButton()
    
    private var disposeBag = DisposeBag()
    override func setBinding() {
        numberBtn.rx.tap
            .bind(with: self) { owner, _ in
                guard let number = owner.numberBtn.titleLabel?.text, !number.isEmpty else { return }
                let cleanedNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                if let url = URL(string: "tel://\(cleanedNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
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
        
        numberBtn.titleLabel?.font = .smallSemibold
        numberBtn.setTitleColor(.point, for: .normal)
    }
    
    override func configureHierarchy() {
        [numLabel, addressLabel, loadLabel, numberBtn].forEach {
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
        
        numberBtn.snp.makeConstraints { make in
            make.top.equalTo(loadLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with entity: MapEntity) {
        numLabel.text = entity.numAddress
        addressLabel.text = entity.address
        numberBtn.setTitle(entity.number, for: .normal)
    }
}
