//
//  BaseViewController.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
        setBinding()
        setupLocationButton()
    }
    
    private func setupLocationButton() {
        let locationRepository = LocationRepository.shared
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "위치 확인 중...",
            style: .plain,
            target: self,
            action: #selector(handleLocationButtonTap)
        )
        
        if locationRepository.authorizationStatus.value == .authorizedWhenInUse ||
            locationRepository.authorizationStatus.value == .authorizedAlways {
            locationRepository.startUpdatingLocation(forceUpdate: true)
            
            locationRepository.currentCity
                .compactMap { $0 }
                .take(1)
                .bind(with: self) { owner, city in
                    owner.navigationItem.rightBarButtonItem?.title = "📍 \(city)"
                }
                .disposed(by: disposeBag)
        } else {
            self.navigationItem.rightBarButtonItem?.title = "📍 전국"
        }
    }
    
    @objc func handleLocationButtonTap() {
        let locationRepository = LocationRepository.shared
        
        switch locationRepository.authorizationStatus.value {
        case .authorizedWhenInUse, .authorizedAlways:
            locationRepository.startUpdatingLocation(forceUpdate: true)
            
            locationRepository.currentCity
                .compactMap { $0 }
                .take(1)
                .bind(with: self) { owner, city in
                    owner.navigationItem.rightBarButtonItem?.title = "📍 \(city)"
                }
                .disposed(by: disposeBag)
            
        case .denied, .restricted, .notDetermined:
            showSettingsAlert(
                title: "위치 권한 필요",
                message: "위치 서비스를 사용하려면 설정에서 권한을 허용해주세요."
            )
        @unknown default:
            break
        }
    }
    
    
    func setBinding() { }
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
    
    deinit {
        print(#function, self)
    }
}
