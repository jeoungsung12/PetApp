//
//  SponsorCollectionViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SponsorCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private let imageBtn = UIButton()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private var siteURL: String?
    private var disposeBag = DisposeBag()
    override func setBinding() {
        imageBtn.rx.tap
            .bind(with: self) { owner, _ in
                guard let siteURL = owner.siteURL,
                let url = URL(string: siteURL) else { return }
                UIApplication.shared.open(url)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.frame.width / 2
        imageView.backgroundColor = .customLightGray
        
        nameLabel.font = .mediumBold
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .customWhite
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.shadowColor = UIColor.customBlack.cgColor
        
        imageBtn.clipsToBounds = true
        imageBtn.layer.cornerRadius = self.frame.width / 2
        imageBtn.backgroundColor = .customLightGray
    }
    
    override func configureHierarchy() {
        [imageView, nameLabel].forEach {
            self.imageBtn.addSubview($0)
        }
        contentView.addSubview(imageBtn)
    }
    
    override func configureLayout() {
        imageBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func configure(_ entity: SponsorViewModel.SponsorEntity) {
        imageView.image = UIImage(named: entity.image)
        nameLabel.text = entity.title
        self.siteURL = entity.siteURL
    }
}
