//
//  DetailMiddleCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SnapKit

final class DetailMiddleCell: BaseTableViewCell, ReusableIdentifier {
    private let statusLabel = UILabel()
    private let heartBtn = UIButton()
    private let shareBtn = UIButton()
    private let lineStackView = LineByStackView()
    private let charView = CharacteristicView()
    
    override func configureView() {
        statusLabel.textColor = .point
        statusLabel.font = .largeBold
        
        heartBtn.setImage(.heartImage, for: .normal)
        heartBtn.tintColor = .customBlack
        
        shareBtn.setImage(.shareImage, for: .normal)
        shareBtn.tintColor = .customBlack
    }
    
    override func configureHierarchy() {
        [statusLabel, heartBtn, shareBtn, lineStackView, charView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        statusLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
        }
        
        heartBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(68)
        }
        
        shareBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(9)
        }
        
        lineStackView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(heartBtn.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        charView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(lineStackView.snp.bottom).offset(24)
        }
    }
    
    func configure(_ entity: HomeEntity) {
        statusLabel.text = entity.animal.state
        
        lineStackView.configure(
            [
                .init(title: "구조된 장소", subTitle: entity.shelter.discplc),
                .init(title: "성별", subTitle: entity.animal.gender),
                .init(title: "중성화 여부", subTitle: entity.animal.neut)
            ]
        )
        
        charView.configure(entity)
    }
    
}
