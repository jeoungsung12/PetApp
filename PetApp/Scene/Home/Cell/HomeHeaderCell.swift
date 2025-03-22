//
//  HomeHeaderCell.swift
//  Moving
//
//  Created by 조우현 on 3/21/25.
//

import UIKit
import Kingfisher
import SnapKit

final class HomeHeaderCell: BaseCollectionViewCell, ReusableIdentifier {
    private let posterImageView = UIImageView()
    
    override func configureHierarchy() {
        [posterImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        //TODO: Timer
        posterImageView.image = UIImage(named: "poster6")
        posterImageView.backgroundColor = .customLightGray
        posterImageView.contentMode = .scaleToFill
    }
}
