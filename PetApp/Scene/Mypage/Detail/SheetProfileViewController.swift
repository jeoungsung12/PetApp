//
//  SheetProfileViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/27/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class SheetProfileViewController: BaseViewController {
    private lazy var hideGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    private let profileButton = CustomProfileButton(120, true)
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    private let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    private let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
    private var profileImage: String?
    
    private let viewModel: ProfileViewModel
    private var inputTrigger = ProfileViewModel.Input(
        configureViewTrigger: PublishSubject<Void>(),
        nameTextFieldTrigger: PublishSubject<String?>(),
        successButtonTrigger: PublishSubject<ProfileButton>(),
        buttonEnabledTrigger: PublishSubject<ProfileButton>()
    )
    
    private var disposeBag = DisposeBag()
    
    weak var coordinator: MyPageCoordinator?
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            coordinator?.finish()
        }
    }
    
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
                    owner.profileImage = userInfo.image
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
                    owner.coordinator?.popSheetProfile()
                } else {
                    owner.view.makeToast("저장에 실패했습니다!", duration: 1, position: .center)
                }
            }).disposed(by: disposeBag)
        
        output.nameTextFieldResult
            .drive(with: self, onNext: { owner, text in
                owner.descriptionLabel.text = ((text == "")) ? nil : text
                owner.descriptionLabel.textColor = (text == NickName.NickNameType.success.rawValue) ? .black : .point
            }).disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.enableTrigger(false)
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.popSheetProfile()
            }
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.showProfileImageSelection(currentImage: owner.profileImage, delegate: owner)
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
        [profileButton, nameTextField, spacingView, descriptionLabel].forEach {
            self.view.addSubview($0)
        }
        self.navigationItem.rightBarButtonItems = [saveButton, cancelButton]
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
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension SheetProfileViewController: UITextFieldDelegate, ProfileImageDelegate {
    func returnImage(_ image: String?) {
        guard let image = image else { return }
        self.profileImage = image
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

