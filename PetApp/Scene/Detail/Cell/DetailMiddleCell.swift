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
        statusLabel.text = "보호중"
        statusLabel.textColor = .point
        statusLabel.font = .mediumBold
        
        heartBtn.setImage(.heartImage, for: .normal)
        shareBtn.setImage(.shareImage, for: .normal)
    }
    
    override func configureHierarchy() {
        [statusLabel, shareBtn, heartBtn, lineStackView, charView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        statusLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        
        shareBtn.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        heartBtn.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalToSuperview().inset(12)
            make.trailing.equalTo(shareBtn.snp.leading).inset(8)
        }
        
        lineStackView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(heartBtn.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        charView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(lineStackView.snp.bottom).offset(12)
        }
    }
    
    func configure() {
        lineStackView.configure(
            [
                .init(title: "구조된 장소", subTitle: "고덕면: 방축3길 81-27"),
                .init(title: "성별", subTitle: "🚹"),
                .init(title: "중성화 여부", subTitle: "N")
            ]
        )
    }
    
}
