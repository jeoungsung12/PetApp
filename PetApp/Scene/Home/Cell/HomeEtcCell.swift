//
//  HomeEtcCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/23/25.
//

import UIKit
import SnapKit

enum HomeEtcType {
    case map
    case ads
}

final class HomeEtcCell: BaseCollectionViewCell, ReusableIdentifier {
    private let adsImageView = UIImageView()
    private let mapView = IconLabelButton()
    private let seperateView = SeperateView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = false
        adsImageView.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [adsImageView, mapView].forEach {
            $0.isHidden = false
        }
    }
    
    override func configureView() {
        adsImageView.image = UIImage(named: "Ads")
        adsImageView.backgroundColor = .clear
        adsImageView.contentMode = .scaleAspectFill
        adsImageView.clipsToBounds = true
        adsImageView.layer.cornerRadius = 15
        
        mapView.backgroundColor = .clear
        mapView.configure(image: .mapImage, title: "가까운 동물보호소 알아보기")
    }
    
    override func configureHierarchy() {
        [adsImageView, mapView, seperateView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        adsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(80)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        
        seperateView.snp.makeConstraints { make in
            if adsImageView.isHidden {
                make.top.equalTo(mapView.snp.bottom).offset(24)
            } else {
                make.top.equalTo(adsImageView.snp.bottom).offset(24)
            }
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(_ type: HomeEtcType) {
        switch type {
        case .map:
            adsImageView.isHidden = true
        case .ads:
            mapView.isHidden = true
        }
    }
}
