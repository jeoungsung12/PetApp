//
//  DetailHeaderCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit
import SNKit
import Kingfisher
import SnapKit

final class DetailHeaderCell: BaseTableViewCell, ReusableIdentifier {
    private let backdropImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backdropImageView.image = nil
    }
    
    override func configureView() {
        backdropImageView.clipsToBounds = true
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.tintColor = .customLightGray
        backdropImageView.backgroundColor = .systemGray5
        backdropImageView.layer.borderWidth = 0.3
        backdropImageView.layer.borderColor = UIColor.customLightGray.cgColor
        
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        subTitleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        subTitleLabel.numberOfLines = 2
        
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
            backdropImageView.snSetImage(
                with: url,
                storageOption: .hybrid,
                processingOption: .downsample(CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.1))
            ) { [weak self] result in
                switch result {
                case .success(let image):
                    print("이미지 로드 성공 \(image)")
                    print(url)
                case .failure(let error):
                    print("이미지 로드 에러 \(error), \(url)")
                    self?.backdropImageView.image = .noImage
                    self?.backdropImageView.contentMode = .scaleAspectFit
                }
            }
//            backdropImageView.kf.setImage(with: url)
        }
    }
    
}
