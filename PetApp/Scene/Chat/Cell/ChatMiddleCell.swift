//
//  ChatMiddleCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SnapKit

final class ChatMiddleCell: BaseCollectionViewCell, ReusableIdentifier {
    private let iconView = IconLabelButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        iconView.isUserInteractionEnabled = false
    }
    
    override func configureView() {
        iconView.configure(image: .archiveboxImage, title: "더 많은 친구들과 대화하기")
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(iconView)
    }
    
    override func configureLayout() {
        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
