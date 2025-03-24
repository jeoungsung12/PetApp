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
        iconLabel.configure(image: "", title: "마감 공고까지 7일 남았습니다")
        
        [characterItem, dateItem].forEach {
            self.addSubview($0)
        }
        
        characterItem.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        dateItem.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(characterItem.snp.bottom)
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
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 25
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.borderColor = UIColor.point.cgColor
        
        self.layer.borderColor = UIColor.customLightGray.cgColor
        iconImageView.tintColor = UIColor.customLightGray
        
        titleLabel.font = .largeBold
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
            make.trailing.equalTo(titleLabel.snp.leading).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(50)
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
        
        if let url = URL(string: image) {
            iconImageView.kf.setImage(with: url)
        }
    }

}
