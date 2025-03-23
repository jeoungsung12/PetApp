//
//  HomeEtcCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/23/25.
//

import UIKit
import Kingfisher
import SnapKit

enum HomeEtcType {
    case map
    case ads
}

final class HomeEtcCell: BaseCollectionViewCell, ReusableIdentifier {
    private let adsImageView = UIImageView()
    private let mapView = IconLabelView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        adsImageView.image = nil
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
        [adsImageView, mapView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        adsImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
