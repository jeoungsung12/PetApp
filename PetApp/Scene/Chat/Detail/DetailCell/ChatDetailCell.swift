//
//  ChatDetailCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import Kingfisher
import SnapKit

final class ChatDetailCell: BaseTableViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private var chatType: ChatType?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
        [titleLabel, messageLabel].forEach {
            $0.text = nil
        }
    }
    
    override func configureView() {
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.layer.cornerRadius = 25
        thumbImageView.backgroundColor = .customLightGray
        
        titleLabel.textColor = .customLightGray
        titleLabel.font = .mediumSemibold
        titleLabel.textAlignment = (chatType == .bot) ? .left : .right
        
        messageLabel.clipsToBounds = true
        messageLabel.layer.cornerRadius = 10
        messageLabel.backgroundColor = (chatType == .bot) ? .customLightGray : .point.withAlphaComponent(0.3)
        
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .customBlack
        messageLabel.font = .mediumRegular
        messageLabel.textAlignment = .left
    }
    
    override func configureHierarchy() {
        [thumbImageView, titleLabel, messageLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        guard let chatType = chatType else { return }
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.equalToSuperview().inset(12)
            switch chatType {
            case .bot:
                make.leading.equalToSuperview().inset(12)
            case .mine:
                make.trailing.equalToSuperview().inset(12)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            switch chatType {
            case .bot:
                make.trailing.equalToSuperview().inset(12)
                make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
            case .mine:
                make.leading.equalToSuperview().inset(12)
                make.trailing.equalTo(thumbImageView.snp.leading).inset(8)
            }
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(12)
            switch chatType {
            case .bot:
                make.trailing.lessThanOrEqualToSuperview().inset(12)
                make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
            case .mine:
                make.leading.greaterThanOrEqualToSuperview().inset(12)
                make.trailing.equalTo(thumbImageView.snp.leading).inset(8)
            }
        }
    }
    
    func configure(_ entity: ChatEntity) {
        self.chatType = entity.type
        
        titleLabel.text = entity.name
        messageLabel.text = entity.message
        
        thumbImageView.image = UIImage(named: "mockImage")
        //        if let url = URL(string: entity.thumbImage) {
        //            thumbImageView.kf.setImage(with: url)
        //        }
        
        configureView()
        configureLayout()
    }
}
