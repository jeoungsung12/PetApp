//
//  DetailHeaderCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SnapKit

final class DetailHeaderCell: BaseTableViewCell, ReusableIdentifier {
    private let backdropImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    
    override func configureView() {
        backdropImageView.contentMode = .scaleAspectFill
        
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        subTitleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        
        [titleLabel, subTitleLabel].forEach {
            $0.textAlignment = .left
            $0.textColor = .customWhite
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.layer.shadowColor = UIColor.customBlack.cgColor
        }
    }
    
    override func configureHierarchy() {
        [backdropImageView, subTitleLabel, titleLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        backdropImageView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width * 1.1)
            make.edges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(subTitleLabel.snp.top).offset(24)
        }
    }
    
    //TODO: Entity
    func configure() {
        backdropImageView.image = UIImage(named: "mockImage")
        titleLabel.text = "믹스견"
        subTitleLabel.text = "3KG 60일 미만"
    }
    
}
