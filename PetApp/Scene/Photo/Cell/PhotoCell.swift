//
//  PhotoCell.swift
//  PetApp
//
//  Created by 정성윤 on 4/5/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PhotoCell: BaseCollectionViewCell, ReusableIdentifier {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ image: String) {
        guard let url = URL(string: image) else { return }
        
        imageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.layoutIfNeeded()
            case .failure(let error):
                print("이미지 로드 실패: \(error)")
            }
        }
    }
}
