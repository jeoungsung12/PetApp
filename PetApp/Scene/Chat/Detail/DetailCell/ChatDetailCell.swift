//
//  ChatDetailCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SNKit
import Kingfisher
import SnapKit

final class ChatDetailCell: BaseTableViewCell, ReusableIdentifier {
    private let thumbImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private var chatType: ChatType?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
        [titleLabel, messageLabel].forEach {
            $0.text = nil
        }
        titleLabel.isHidden = false
        thumbImageView.isHidden = false
    }
    
    override func configureView() {
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.layer.cornerRadius = 25
        thumbImageView.backgroundColor = .customLightGray
        
        titleLabel.textColor = .customLightGray
        titleLabel.font = .mediumSemibold
        titleLabel.textAlignment = (chatType == .bot) ? .left : .right
        
        bubbleView.clipsToBounds = true
        bubbleView.layer.cornerRadius = 10
        bubbleView.backgroundColor = (chatType == .bot) ? .systemGray5 : .point.withAlphaComponent(0.3)
        
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .customBlack
        messageLabel.font = .mediumRegular
        messageLabel.textAlignment = .left
    }
    
    override func configureHierarchy() {
        bubbleView.addSubview(messageLabel)
        [thumbImageView, titleLabel, bubbleView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        guard let chatType = chatType else { return }
        
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
        }
        
        bubbleView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            switch chatType {
            case .bot:
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.trailing.lessThanOrEqualToSuperview().inset(12)
                make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
            case .mine:
                make.top.equalToSuperview().offset(8)
                make.trailing.equalToSuperview().inset(12)
                make.leading.greaterThanOrEqualToSuperview().inset(12)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.8).priority(.high)
            }
        }
        
        messageLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    func configure(_ entity: ChatEntity) {
        self.chatType = entity.type
        switch entity.type {
        case .bot:
            thumbImageView.isHidden = false
            titleLabel.isHidden = false
        case .mine:
            thumbImageView.isHidden = true
            titleLabel.isHidden = true
        }
        
        titleLabel.text = entity.name
        messageLabel.text = entity.message
        
        if let url = URL(string: entity.thumbImage) {
            thumbImageView.snSetImage(
                with: url,
                storageOption: .hybrid,
                processingOption: .downsample(CGSize(width: 50, height: 50))
            )
//            thumbImageView.kf.setImage(with: url)
        }
        
        configureView()
        configureLayout()
    }
}
