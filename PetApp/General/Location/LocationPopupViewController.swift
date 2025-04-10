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
import CoreLocation

protocol LocationDelegate: AnyObject {
    func reloadLoaction(_ locationEntity: LocationViewModel.LocationEntity)
}

final class LocationPopupViewController: BaseViewController {
    private lazy var dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView))
    private let containerView = UIStackView()
    private let allRegionButton = UIButton()
    private let userRegionButton = UIButton()
    private let userLocation: LocationViewModel.LocationEntity
    private var disposeBag = DisposeBag()
    private let locationManager: LocationRepositoryType
    
    weak var delegate: LocationDelegate?
    init(
        userLocation: LocationViewModel.LocationEntity,
        locationManager: LocationRepositoryType? = nil
    ) {
        self.userLocation = userLocation
        self.locationManager = locationManager ?? DIContainer.shared.resolve(type: LocationRepositoryType.self)!
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setBinding() {
        allRegionButton.rx.tap
            .bind(with: self) { owner, _ in
                let nationwideEntity = LocationViewModel.LocationEntity(city: "전국", location: nil)
                owner.delegate?.reloadLoaction(nationwideEntity)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        userRegionButton.rx.tap
            .bind(with: self) { owner, _ in
                let authStatus = CLLocationManager.authorizationStatus()
                
                if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
                    if owner.hasValidUserLocation() {
                        owner.delegate?.reloadLoaction(owner.userLocation)
                    } else {
                        owner.locationManager.startUpdatingLocation(forceUpdate: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let location = owner.locationManager.currentLocation.value {
                                owner.locationManager.reverseGeocode(coordinate: location) { address, city in
                                    let entity = LocationViewModel.LocationEntity(
                                        city: city ?? "현재 위치",
                                        location: location
                                    )
                                    owner.delegate?.reloadLoaction(entity)
                                }
                            }
                            owner.dismiss(animated: true)
                        }
                    }
                } else {
                    owner.showSettingsAlert(title: "위치 권한 필요", message: "위치 서비스를 사용하려면 설정에서 권한을 허용해주세요.")
                }
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
        let authStatus = CLLocationManager.authorizationStatus()
        let hasLocationPermission = authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways
        
        allRegionButton.setTitle("전국", for: .normal)
        
        if hasLocationPermission {
            userRegionButton.setTitle(hasValidUserLocation() ? "\(userLocation.city)(현위치)" : "현재 위치 가져오기", for: .normal)
        } else {
            userRegionButton.setTitle("위치 권한 설정", for: .normal)
        }
        
        [allRegionButton, userRegionButton].forEach {
            $0.setTitleColor(.customBlack, for: .normal)
            $0.titleLabel?.font = .largeBold
        }
    }
    
    override func configureHierarchy() {
        [allRegionButton, userRegionButton].forEach {
            self.containerView.addArrangedSubview($0)
        }
        self.view.addGestureRecognizer(dismissGesture)
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
    
    private func hasValidUserLocation() -> Bool {
        return userLocation.location != nil && userLocation.city != "전국"
    }
    
    @objc
    private func dismissPopupView() {
        self.dismiss(animated: true)
    }
}
