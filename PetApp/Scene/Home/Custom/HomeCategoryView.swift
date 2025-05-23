//
//  HomeCategoryView.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum CategoryType {
    case shelter
    case hospital
    case heart
    case sponsor
}

protocol CategoryDelegate: AnyObject {
    func didTapCategory(_ type: CategoryType)
}

final class HomeCategoryView: BaseView {
    private let stackView = UIStackView()
    
    private let shelterContainer = UIButton()
    private let hospitalContainer = UIButton()
    private let heartContainer = UIButton()
    private let sponsorContainer = UIButton()
    
    private let shelterImageView = UIImageView()
    private let hospitalImageView = UIImageView()
    private let heartImageView = UIImageView()
    private let sponsorImageView = UIImageView()
    
    private let shelterLabel = UILabel()
    private let hospitalLabel = UILabel()
    private let heartLabel = UILabel()
    private let sponsorLabel = UILabel()
    
    private var disposeBag = DisposeBag()
    weak var delegate: CategoryDelegate?
    private let categories: [(image: UIImage?, title: String)] = [
        (UIImage(named: "Shelter"), "보호소"),
        (UIImage(named: "Hospital"), "동물병원"),
        (UIImage(named: "Heart"), "관심"),
        (UIImage(named: "Sponsor"), "후원")
    ]
    
    override func setBinding() {
        shelterContainer.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.didTapCategory(.shelter)
            }
            .disposed(by: disposeBag)
        
        hospitalContainer.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.didTapCategory(.hospital)
            }
            .disposed(by: disposeBag)
        
        heartContainer.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.didTapCategory(.heart)
            }
            .disposed(by: disposeBag)
        
        sponsorContainer.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.didTapCategory(.sponsor)
            }
            .disposed(by: disposeBag)
    }
    
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
