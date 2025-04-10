//
//  LocationButton.swift
//  PetApp
//
//  Created by 정성윤 on 4/7/25.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LocationButton: BaseButton {
    private let iconImageView = UIImageView()
    private(set) var subTitleLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView()
    
    private(set) var viewModel = LocationViewModel()
    private var disposeBag = DisposeBag()
    private let loadTrigger = PublishRelay<Void>()
    private var locationReadySubject = PublishSubject<LocationViewModel.LocationEntity>()
    private var hasEmittedLocation = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBinding()
    }
    
    private func setBinding() {
        let input = LocationViewModel.Input(
            loadTrigger: loadTrigger
        )
        let output = viewModel.transform(input)
        loadTrigger.accept(())
        loadingIndicator.startAnimating()
        
        loadTrigger.asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.loadingIndicator.startAnimating()
            }
            .disposed(by: disposeBag)
        
        output.locationResult
            .drive(with: self) { owner, entity in
                owner.subTitleLabel.text = entity.city
                owner.loadingIndicator.stopAnimating()
                
                if !owner.hasEmittedLocation {
                    owner.hasEmittedLocation = true
                    owner.locationReadySubject.onNext(entity)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        iconImageView.image = UIImage(systemName: "mappin.and.ellipse.circle.fill")
        iconImageView.contentMode = .scaleAspectFit
        
        subTitleLabel.font = .mediumBold
        subTitleLabel.textAlignment = .center
        
        subTitleLabel.textColor = .customLightGray
        iconImageView.tintColor = .point.withAlphaComponent(0.8)
        
        loadingIndicator.color = .customLightGray
        loadingIndicator.style = .medium
    }
    
    override func configureHierarchy() {
        [
            subTitleLabel,
            iconImageView,
            loadingIndicator
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(subTitleLabel.snp.leading).offset(-8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(4)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    func configure(_ locationEntity: LocationViewModel.LocationEntity) {
        subTitleLabel.text = locationEntity.city
        viewModel.updateLocation(locationEntity)
    }
    
    func waitForLocationReady(completion: @escaping (LocationViewModel.LocationEntity) -> Void) {
        if hasEmittedLocation {
            completion(viewModel.currentLocationEntity.value)
            return
        }
        
        locationReadySubject
            .take(1)
            .bind(with: self, onNext: { owner, entity in
                completion(entity)
            })
            .disposed(by: disposeBag)
    }
}
