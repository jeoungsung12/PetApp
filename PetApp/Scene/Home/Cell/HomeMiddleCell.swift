//
//  HomeMiddleCell.swift
//  Moving
//
//  Created by 조우현 on 3/21/25.
//

import UIKit
import Kingfisher
import SnapKit

final class HomeMiddleCell: BaseCollectionViewCell, ReusableIdentifier {
    private let thumbImageview = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = true
    }
    
    override func configureView() {
        thumbImageview.clipsToBounds = true
        thumbImageview.contentMode = .scaleToFill
        thumbImageview.layer.cornerRadius = 5
        thumbImageview.backgroundColor = .customLightGray
        
        titleLabel.textColor = .customBlack
        titleLabel.font = .mediumBold
        
        subTitleLabel.textColor = .customLightGray
        subTitleLabel.font = .mediumRegular
        
        [titleLabel, subTitleLabel].forEach {
            $0.textAlignment = .left
        }
    }
    
    override func configureHierarchy() {
        [thumbImageview, titleLabel, subTitleLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(thumbImageview.snp.bottom).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    func configure(_ model: HomeEntity) {
        titleLabel.text = model.title
        subTitleLabel.text = model.category
        
        if let url = URL(string: model.thumbImage) {
            thumbImageview.kf.setImage(with: url)
        }
    }
    
}
