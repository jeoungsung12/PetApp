//
//  ListTableViewCell.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import SNKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

final class ListTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let thumbImageview = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusLabel = UILabel()
    private let dateLabel = UILabel()
    private let weightLabel = UILabel()
    
    private let viewModel = ListTableViewModel()
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageview.image = nil
        thumbImageview.contentMode = .scaleAspectFill
    }
    
    override func configureView() {
        thumbImageview.clipsToBounds = true
        thumbImageview.contentMode = .scaleAspectFill
        thumbImageview.layer.cornerRadius = 10
        thumbImageview.tintColor = .customLightGray
        thumbImageview.backgroundColor = .systemGray5
        thumbImageview.layer.borderWidth = 0.3
        thumbImageview.layer.borderColor = UIColor.customLightGray.cgColor
        
        titleLabel.textColor = .customLightGray
        titleLabel.font = .mediumRegular
        
        subTitleLabel.textColor = .customBlack
        subTitleLabel.font = .headLine
        subTitleLabel.numberOfLines = 2
        
        descriptionLabel.textColor = .customBlack
        descriptionLabel.font = .mediumRegular
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        
        [titleLabel, subTitleLabel].forEach {
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        statusLabel.clipsToBounds = true
        statusLabel.font = .mediumBold
        statusLabel.layer.cornerRadius = 5
        statusLabel.textColor = .customLightGray
        statusLabel.backgroundColor = .systemGray5
        statusLabel.textAlignment = .center
        
        dateLabel.font = .mediumBold
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = 5
        dateLabel.textColor = .customWhite
        dateLabel.backgroundColor = .systemRed.withAlphaComponent(0.7)
        
        weightLabel.font = .mediumSemibold
        weightLabel.numberOfLines = 1
    }
    
    override func configureHierarchy() {
        [
            thumbImageview,
            dateLabel,
            titleLabel,
            descriptionLabel,
            weightLabel,
            subTitleLabel,
            statusLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        thumbImageview.snp.makeConstraints { make in
            make.size.equalTo(180)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(thumbImageview.snp.top).offset(8)
            make.leading.equalTo(thumbImageview.snp.leading).offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(thumbImageview.snp.top)
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(25)
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualTo(thumbImageview.snp.bottom).inset(4)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(weightLabel.snp.bottom).offset(8)
            make.leading.equalTo(thumbImageview.snp.trailing).offset(12)
        }
    }
    
    func configure(_ model: HomeEntity?) {
        guard let model = model else { return }
        statusLabel.text = model.animal.state
        titleLabel.text = model.shelter.name
        descriptionLabel.text = model.animal.description
        dateLabel.text = " \(model.shelter.endDate.toDate())일 남음 "
        weightLabel.text = "\(model.animal.age) \(model.animal.weight)"
        
        if let url = URL(string: model.animal.fullImage) {
            thumbImageview.snSetImage(
                with: url,
                storageOption: .hybrid,
                processingOption: .downsample(CGSize(width: 180, height: 180))
            ) { [weak self] result in
                switch result {
                case .success(let image):
                    print("이미지 로드 성공 \(image)")
                case .failure(let error):
                    print("이미지 로드 에러 \(error), \(url)")
                    self?.thumbImageview.image = .noImage
                    self?.thumbImageview.contentMode = .scaleAspectFit
                }
            }
//            thumbImageview.kf.setImage(with: url)
        }
        configureSubTitle(model: model)
    }
    
    private func configureSubTitle(model: HomeEntity) {
        let genderText = (model.animal.gender == "🚹") ? "남" : "여"
        let nameText = model.animal.name
        let fullText = "\(genderText), \(nameText)"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let colorRange = (fullText as NSString).range(of: genderText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.point, range: colorRange)
        
        let nameRange = (fullText as NSString).range(of: nameText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.customBlack, range: nameRange)
        subTitleLabel.attributedText = attributedString
    }
    
}
