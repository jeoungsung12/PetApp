//
//  CharacteristicView.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SNKit
import SnapKit

final class CharacteristicView: BaseView {
    
    func configure(_ entity: HomeEntity) {
        let characterItem = LineItemView("특징 🐾", entity.animal.description, .left)
        let dateItem = LineItemView(
            "공고일자 🗓️",
            "\(entity.shelter.beginDate) ~ \(entity.shelter.endDate)",
            .left
        )
        
        let iconLabel = IconAttributeView()
        let seperateView = SeperateView()
        iconLabel.configure(image: entity.animal.thumbImage, endDate: entity.shelter.endDate)
        
        [characterItem, dateItem, iconLabel, seperateView].forEach {
            self.addSubview($0)
        }
        
        characterItem.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        dateItem.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(characterItem.snp.bottom).offset(12)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(dateItem.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        seperateView.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(iconLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

fileprivate class IconAttributeView: BaseView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.customLightGray.cgColor
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 40
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.borderColor = UIColor.point.cgColor
        iconImageView.tintColor = UIColor.customLightGray
        
        titleLabel.font = .largeBold
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
    }
    
    override func configureHierarchy() {
        [titleLabel, iconImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(titleLabel.snp.leading).offset(-36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(50)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    func configure(image: String, endDate: String) {
        if let url = URL(string: image) {
            iconImageView.snSetImage(with: url, storageOption: .memory)
        }
        
        let date: Date = endDate.toDate()
        print(endDate)
        let today = Date()
        let daysRemaining = Calendar.current.dateComponents([.day], from: today, to: date).day ?? 0
        
        let title = "공고 마감까지\n\(daysRemaining)일 남음"
        
        let attributedString = NSMutableAttributedString(string: title)
        
        if let range = title.range(of: "\(daysRemaining)일 남음") {
            let nsRange = NSRange(range, in: title)
            attributedString.addAttributes([
                .font: UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor: UIColor.point
            ], range: nsRange)
        }
        
        titleLabel.attributedText = attributedString
    }

}
