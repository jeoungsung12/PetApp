//
//  ProfileViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController {
    private lazy var hideGesture = UITapGestureRecognizer(target: self, action: #selector(self.tabGestureAction))
    private let profileButton = CustomProfileButton(120, true)
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    private let successButton = UIButton()
    private var profileImage: String?
    
    private let viewModel = ProfileViewModel()
    private var inputTrigger = ProfileViewModel.Input(
        configureViewTrigger: PublishSubject<Void>(),
        nameTextFieldTrigger: PublishSubject<String?>(),
        successButtonTrigger: PublishSubject<ProfileButton>(),
        buttonEnabledTrigger: PublishSubject<ProfileButton>()
    )
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func setBinding() {
        let output = viewModel.transform(inputTrigger)
        
        output.configureViewResult
            .drive(with: self, onNext: { owner, userInfo in
                if let userInfo = userInfo {
                    owner.nameTextField.text = userInfo.name
                    owner.profileButton.profileImage.image = UIImage(named: userInfo.image)
                } else {
                    guard let image = ProfileData.allCases.randomElement()?.rawValue else { return }
                    owner.profileImage = image
                    owner.profileButton.profileImage.image = UIImage(named: image)
                }
            }).disposed(by: disposeBag)
        
        output.successButtonResult
            .drive(with: self, onNext: { owner, valid in
                if let valid = valid, valid {
                    let rootVC = TabBarController()
                    owner.setRootView(rootVC)
                }
            }).disposed(by: disposeBag)
        
        output.nameTextFieldResult
            .drive(with: self, onNext: { owner, text in
                owner.descriptionLabel.text = ((text == "")) ? nil : text
                owner.descriptionLabel.textColor = (text == NickName.NickNameType.success.rawValue) ? .black : .point
            }).disposed(by: disposeBag)
        
        output.buttonEnabledResult
            .drive(with: self, onNext: { owner, valid in
                guard let valid = valid else {
                    owner.successButton.isEnabled = false
                    owner.successButton.backgroundColor = .customLightGray
                    return
                }
                owner.successButton.isEnabled = (valid) ? true : false
                owner.successButton.backgroundColor = (valid) ? .point : .customLightGray
            }).disposed(by: disposeBag)
        
        
        successButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.enableTrigger(false)
            }
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = ProfileImageViewController()
                vc.profileImage = owner.profileImage
                vc.profileDelegate = owner
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.changed
            .bind(with: self) { owner, value in
                owner.enableTrigger(true)
            }
            .disposed(by: disposeBag)
        
        inputTrigger.configureViewTrigger.onNext(())
    }
    
    override func configureHierarchy() {
        [profileButton, nameTextField, spacingView, descriptionLabel, successButton].forEach {
            self.view.addSubview($0)
        }
        self.view.addGestureRecognizer(hideGesture)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(profileButton.snp.bottom).offset(24)
        }
        
        spacingView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(spacingView.snp.bottom).offset(16)
        }
        
        successButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
        }
    }
    
    override func configureView() {
        self.setNavigation(logo: true)
        self.view.backgroundColor = .customWhite
        
        nameTextField.delegate = self
        nameTextField.textColor = .black
        nameTextField.textAlignment = .left
        nameTextField.placeholder = "닉네임을 설정해 주세요!"
        nameTextField.font = .systemFont(ofSize: 15, weight: .semibold)
        
        spacingView.backgroundColor = .customLightGray
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .point
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        successButton.isEnabled = false
        successButton.clipsToBounds = true
        successButton.layer.cornerRadius = 20
        successButton.backgroundColor = .customLightGray
        successButton.setTitle("완료", for: .normal)
        successButton.setTitleColor(.white, for: .normal)
        
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension ProfileViewController: UITextFieldDelegate, ProfileImageDelegate {
    func returnImage(_ image: String?) {
        guard let image = image else { return }
        self.profileButton.profileImage.image = UIImage(named: image)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputTrigger.nameTextFieldTrigger.onNext(textField.text)
        enableTrigger(true)
    }
    
    private func checkTapped() {
        enableTrigger(true)
    }
    
    private func enableTrigger(_ enable: Bool) {
        let trigger = (enable) ? inputTrigger.buttonEnabledTrigger : inputTrigger.successButtonTrigger
        if let nickname = nameTextField.text, let description = descriptionLabel.text,
           let profileImage = self.profileImage {
            trigger.onNext(ProfileButton(profileImage: profileImage, name: nickname, description: description))
        }
    }
    
}
