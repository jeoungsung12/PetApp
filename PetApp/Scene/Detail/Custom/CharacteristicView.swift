//
//  CharacteristicView.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import Kingfisher
import SnapKit

final class CharacteristicView: BaseView {
    
    func configure(_ char: String,_ date: String) {
        let characterItem = LineItemView("특징 🐾", char, .left)
        let dateItem = LineItemView("공고일자 🗓️", date, .left)
        let iconLabel = IconAttributeView()
        let seperateView = SeperateView()
        iconLabel.configure(image: "", title: "공고 마감까지 7일 남았습니다")
        
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
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 25
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.borderColor = UIColor.point.cgColor
        
        self.layer.borderColor = UIColor.customLightGray.cgColor
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
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(titleLabel.snp.leading).offset(-24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    func configure(image: String, title: String) {
        let attributedString = NSMutableAttributedString(string: title)
        
        let range = NSRange(location: 0, length: min(2, title.count))
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        
        titleLabel.attributedText = attributedString
        
        iconImageView.image = UIImage(named: "mockImage")
        //        if let url = URL(string: image) {
        //            iconImageView.kf.setImage(with: url)
        //        }
    }
    
}
