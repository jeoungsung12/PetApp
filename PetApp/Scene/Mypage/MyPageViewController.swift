//
//  MypageViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageViewController: BaseViewController {
    private let myProfileView = MyProfileView()
    private let buttonStackView = UIStackView()
    private let categoryStackView = UIStackView()
    private let countLabel = UILabel()
    private let aniBoxButton = UIButton()
    private let changeProfileButton = UIButton()
    
    private let viewModel = MyPageViewModel()
    let inputTrigger = MyPageViewModel.Input(
        profileTrigger: PublishRelay<Void>(),
        listBtnTrigger: PublishRelay<MyPageViewModel.MyPageButtonType>(),
        categoryBtnTrigger: PublishRelay<MyPageViewModel.MyPageCategoryType>()
    )
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.profileTrigger.accept(())
    }
    
    override func setBinding() {
        let output = viewModel.transform(inputTrigger)
        
        output.profileResult
            .drive(with: self, onNext: { owner, userInfo in
                guard let userInfo = userInfo else { return }
                owner.myProfileView.configure(userInfo)
                owner.countLabel.text = String(format: "%2d", owner.viewModel.getLikeAnimate())
            }).disposed(by: disposeBag)
        
        output.listBtnResult
            .drive(with: self) { owner, type in
                switch type {
                case .oftenQS:
                    print("자주묻는 질문")
                case .feedback:
                    print("피드백")
                case .withdraw:
                    owner.customAlert(
                        "탈퇴하기",
                        "탈퇴를 하시면 저장된 모든 데이터가 삭제됩니다. 계속하시겠습니까?",
                        [.Ok, .Cancel]
                    ) {
                        owner.viewModel.removeUserInfo()
                        owner.setRootView(UINavigationController(rootViewController: ProfileViewController()))
                    }
                }
            }.disposed(by: disposeBag)
        
        output.categoryBtnResult
            .drive(with: self, onNext: { owner, type in
                switch type {
                case .likeBox:
                    print("관심 등록된")
                case .writeList:
                    print("함께한 시간")
                case .profile:
                    print("프로필 변경")
                }
            }).disposed(by: disposeBag)
        
        [aniBoxButton, changeProfileButton].forEach({ btn in
            btn.rx.tap
                .bind(with: self) { owner, _ in
                    let type = MyPageViewModel.MyPageCategoryType.allCases[btn.tag]
                    owner.inputTrigger.categoryBtnTrigger.accept(type)
                }.disposed(by: disposeBag)
        })
    }
    
    override func configureHierarchy() {
        [aniBoxButton, changeProfileButton].forEach({
            self.categoryStackView.addArrangedSubview($0)
        })
        [myProfileView, categoryStackView, buttonStackView, countLabel].forEach({
            self.view.addSubview($0)
        })
    }
    
    override func configureLayout() {
        
        myProfileView.snp.makeConstraints { make in
            make.height.equalTo(230)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(myProfileView.snp.bottom).offset(12)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(categoryStackView.snp.bottom).offset(24)
        }
        
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.centerX.equalTo(aniBoxButton.snp.centerX)
            make.top.equalTo(aniBoxButton.snp.top).offset(-20)
        }
        
    }
    
    override func configureView() {
        self.setNavigation(logo: true)
        self.view.backgroundColor = .customWhite
        aniBoxButton.tag = 0
        self.buttonConfiguration(aniBoxButton,  MyPageViewModel.MyPageCategoryType.likeBox.rawValue, MyPageViewModel.MyPageCategoryType.likeBox.image)
        
        changeProfileButton.tag = 1
        self.buttonConfiguration(changeProfileButton, MyPageViewModel.MyPageCategoryType.profile.rawValue, MyPageViewModel.MyPageCategoryType.profile.image)
        
        [aniBoxButton, changeProfileButton].forEach({
            $0.tintColor = .black
        })
        categoryStackView.axis = .horizontal
        categoryStackView.alignment = .center
        categoryStackView.distribution = .fillEqually
        
        countLabel.textColor = .white
        countLabel.clipsToBounds = true
        countLabel.layer.cornerRadius = 5
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .point
        countLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        
        configureButtonStack()
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension MyPageViewController {
    
    private func configureButtonStack() {
        buttonStackView.spacing = 30
        buttonStackView.axis = .vertical
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (type) in MyPageViewModel.MyPageButtonType.allCases {
            let button = MyPageSectionButton()
            button.rx.tap
                .bind(with: self) { owner, _ in
                    owner.inputTrigger.listBtnTrigger.accept(type)
                }.disposed(by: disposeBag)
            button.configure(type.rawValue)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func buttonConfiguration(_ btn: UIButton,_ title: String,_ image: String)  {
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.customLightGray, for: .normal)
        btn.setImage(UIImage(systemName: image), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .customLightGray
        //TODO: 이미지 위치 아래에
    }
    
}
