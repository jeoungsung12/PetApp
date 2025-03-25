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
    private let categoryView = CategoryView()
    
    override func configureHierarchy() {
        [posterImageView, categoryView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.contentView.snp.width)
        }
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        //TODO: Timer
        posterImageView.image = UIImage(named: ["poster1","poster2","poster3","poster4","poster5","poster6"].randomElement() ?? "poster1")
        posterImageView.backgroundColor = .customLightGray
        posterImageView.contentMode = .scaleToFill
    }
}

import SnapKit

fileprivate class CategoryView: BaseView {
    private let stackView = UIStackView()
    
    private let shelterContainer = UIView()
    private let hospitalContainer = UIView()
    private let heartContainer = UIView()
    private let sponsorContainer = UIView()
    
    private let shelterImageView = UIImageView()
    private let hospitalImageView = UIImageView()
    private let heartImageView = UIImageView()
    private let sponsorImageView = UIImageView()
    
    private let shelterLabel = UILabel()
    private let hospitalLabel = UILabel()
    private let heartLabel = UILabel()
    private let sponsorLabel = UILabel()
    
    private let categories: [(image: UIImage?, title: String)] = [
        (UIImage(named: "Shelter"), "보호소"),
        (UIImage(named: "Hospital"), "동물병원"),
        (UIImage(named: "Heart"), "관심"),
        (UIImage(named: "Sponsor"), "후원")
    ]
    
    private var containers: [UIView] {
        [shelterContainer, hospitalContainer, heartContainer, sponsorContainer]
    }
    
    private var imageViews: [UIImageView] {
        [shelterImageView, hospitalImageView, heartImageView, sponsorImageView]
    }
    
    private var labels: [UILabel] {
        [shelterLabel, hospitalLabel, heartLabel, sponsorLabel]
    }
    
    override func configureView() {
        setupStackView()
        setupViews()
    }
    
    override func configureHierarchy() {
        addSubview(stackView)
        containers.forEach { container in
            stackView.addArrangedSubview(container)
            container.addSubview(imageViews[containers.firstIndex(of: container)!])
            container.addSubview(labels[containers.firstIndex(of: container)!])
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        for (index, _) in containers.enumerated() {
            let imageView = imageViews[index]
            let label = labels[index]
            
            imageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(5)
                make.width.height.equalTo(30)
            }
            
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.bottom.lessThanOrEqualToSuperview().offset(-5)
            }
        }
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
    }
    
    private func setupViews() {
        for (index, category) in categories.enumerated() {
            let imageView = imageViews[index]
            let label = labels[index]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = category.image
            
            label.text = category.title
            label.textColor = .black
            label.font = .smallSemibold
            label.textAlignment = .center
        }
    }
}
