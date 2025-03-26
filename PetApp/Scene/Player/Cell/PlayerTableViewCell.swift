//
//  PlayerTableViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import UIKit
import SnapKit

final class PlayerTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let emptyView = UIView()
    private let locationLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusLabel = UILabel()
    
    override func configureView() {
        emptyView.backgroundColor = .customLightGray
        emptyView.layer.cornerRadius = 10
    }
    
    override func configureHierarchy() {
        [emptyView, locationLabel, titleLabel, descriptionLabel, statusLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    func configure(_ entity: PlayerEntity) {
        titleLabel.text = entity.name
        statusLabel.text = entity.status
        locationLabel.text = entity.shelter
        descriptionLabel.text = "\(entity.species) \(entity.weight) \(entity.age)"
        //TODO: Video Player
    }
    
}
