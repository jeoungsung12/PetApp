//
//  LocationPopupViewController.swift
//  PetApp
//
//  Created by 정성윤 on 4/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol LocationDelegate: AnyObject {
    func reloadLoaction(_ locationEntity: LocationViewModel.LocationEntity)
}

final class LocationPopupViewController: BaseViewController {
    private let containerView = UIStackView()
    private let allRegionButton = UIButton()
    private let userRegionButton = UIButton()
    private let userLocation: LocationViewModel.LocationEntity
    private var disposeBag = DisposeBag()
    
    weak var delegate: LocationDelegate?
    init(userLocation: LocationViewModel.LocationEntity) {
        self.userLocation = userLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setBinding() {
        allRegionButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.reloadLoaction(owner.userLocation)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        userRegionButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.reloadLoaction(owner.userLocation)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5
        containerView.backgroundColor = .customWhite
        containerView.axis = .vertical
        containerView.spacing = 12
        containerView.alignment = .center
        containerView.distribution = .fillEqually
        
        allRegionButton.setTitle("전국", for: .normal)
        userRegionButton.setTitle(userLocation.city, for: .normal)
        
        [allRegionButton, userRegionButton].forEach {
            $0.setTitleColor(.customBlack, for: .normal)
            $0.titleLabel?.font = .largeBold
        }
    }
    
    override func configureHierarchy() {
        containerView.addArrangedSubview(allRegionButton)
        if userLocation.city != "전국" {
            containerView.addArrangedSubview(userRegionButton)
        }
        self.view.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(100)
        }
    }
    
}
