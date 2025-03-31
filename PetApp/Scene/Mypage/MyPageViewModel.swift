//
//  MyPageViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/11/25.
//

import Foundation
import RxSwift
import RxCocoa

enum MyPageCategoryType: String, CaseIterable {
    case likeBox = "관심\n보관함"
    case writeList = "함께한\n시간"
    case profile = "프로필\n수정"
    
    var image: String {
        switch self {
        case .likeBox:
            "cube.box"
        case .writeList:
            "list.dash"
        case .profile:
            "person.text.rectangle"
        }
    }
}


final class MyPageViewModel: BaseViewModel {
    private let realm: RealmRepositoryType = RealmRepository.shared
    private(set) var profileData = ProfileData.allCases
    private var disposeBag = DisposeBag()
    
    enum MyPageButtonType: String, CaseIterable {
        case oftenQS = "자주묻는 질문"
        case feedback = "피드백 보내기"
        case withdraw = "탈퇴하기"
    }
    
    struct Input {
        let profileTrigger: PublishRelay<Void>
        let listBtnTrigger: PublishRelay<MyPageButtonType>
        let categoryBtnTrigger: PublishRelay<MyPageCategoryType>
    }
    
    struct Output {
        let profileResult: Driver<UserInfo?>
        let listBtnResult: Driver<MyPageButtonType>
        let categoryBtnResult: Driver<MyPageCategoryType>
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension MyPageViewModel {
    
    func transform(_ input: Input) -> Output {
        let profileResult = BehaviorRelay(value: realm.getUserInfo())
        input.profileTrigger
            .bind(with: self) { owner, _ in
                profileResult.accept(owner.realm.getUserInfo())
            }
            .disposed(by: disposeBag)
        
        let categoryResult = PublishRelay<MyPageCategoryType>()
        input.categoryBtnTrigger
            .bind { value in
                categoryResult.accept(value)
            }.disposed(by: disposeBag)
        
        let btnResult = PublishRelay<MyPageButtonType>()
        input.listBtnTrigger
            .bind { value in
                btnResult.accept(value)
            }.disposed(by: disposeBag)
        
        return Output(
            profileResult: profileResult.asDriver(),
            listBtnResult: btnResult.asDriver(onErrorJustReturn: .oftenQS),
            categoryBtnResult: categoryResult.asDriver(onErrorJustReturn: .profile))
    }
    
    func removeUserInfo() {
        realm.deleteUserInfo()
        realm.removeAllRecords()
        realm.removeAllLikedEntity()
    }
    
    func getLikeAnimate() -> Int {
        let save = realm.getAllLikedHomeEntities()
        return save.count
    }
    
}
