//
//  DetailHeaderCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import Kingfisher
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
        [backdropImageView, titleLabel, subTitleLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        backdropImageView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width * 1.1)
            make.edges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subTitleLabel.snp.top).offset(-4)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    func configure(_ entity: HomeEntity) {
        titleLabel.text = entity.animal.name
        subTitleLabel.text = entity.animal.age + " " + entity.animal.weight
        
        if let url = URL(string: entity.animal.fullImage) {
            backdropImageView.kf.setImage(with: url)
        }
    }
    
}
