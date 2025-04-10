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
    private let likeBoxsButton = MypageItemButton(type: MyPageCategoryType.likeBox)
    private let listBoxsButton = MypageItemButton(type: MyPageCategoryType.writeList)
    private let changeProfileButton = MypageItemButton(type: MyPageCategoryType.profile)
    
    private let viewModel: MyPageViewModel
    let inputTrigger = MyPageViewModel.Input(
        profileTrigger: PublishRelay<Void>(),
        listBtnTrigger: PublishRelay<MyPageViewModel.MyPageButtonType>(),
        categoryBtnTrigger: PublishRelay<MyPageCategoryType>()
    )
    private var disposeBag = DisposeBag()
    
    weak var coordinator: MyPageCoordinator?
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                owner.countLabel.text = "\(owner.viewModel.getLikeAnimate())개 게시물 보관중"
            }).disposed(by: disposeBag)
        
        output.listBtnResult
            .drive(with: self) { owner, type in
                switch type {
                case .oftenQS:
                    owner.coordinator?.showFAQ()
                case .feedback:
                    owner.coordinator?.openFeedbackURL(urlString: DataDreamRouter.feedBackURL)
                case .withdraw:
                    owner.coordinator?.showAlert(title: "탈퇴하기", message: "탈퇴를 하시면 저장된 모든 데이터가 삭제됩니다. 계속하시겠습니까?", actions: [.Ok, .Cancel], completion: {
                        owner.viewModel.removeUserInfo()
                        owner.coordinator?.navigateToLogin()
                    })
                }
            }.disposed(by: disposeBag)
        
        output.categoryBtnResult
            .drive(with: self, onNext: { owner, type in
                switch type {
                case .likeBox:
                    owner.coordinator?.showLike()
                case .writeList:
                    owner.coordinator?.showRecord()
                case .profile:
                    owner.coordinator?.showProfileEdit()
                }
            }).disposed(by: disposeBag)
        
        [likeBoxsButton, listBoxsButton, changeProfileButton].forEach({ btn in
            btn.rx.tap
                .bind(with: self) { owner, _ in
                    let type = MyPageCategoryType.allCases[btn.tag]
                    owner.inputTrigger.categoryBtnTrigger.accept(type)
                }.disposed(by: disposeBag)
        })
    }
    
    override func configureHierarchy() {
        [likeBoxsButton, listBoxsButton ,changeProfileButton].forEach({
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
            make.centerX.equalTo(likeBoxsButton.snp.centerX)
            make.top.equalTo(likeBoxsButton.snp.top).offset(-20)
        }
        
    }
    
    override func configureView() {
        self.setTabBar(color: .white)
        self.setNavigation(logo: true)
        self.view.backgroundColor = .customWhite
        likeBoxsButton.tag = 0
        listBoxsButton.tag = 1
        changeProfileButton.tag = 2
        
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
    
}
