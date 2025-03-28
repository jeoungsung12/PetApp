//
//  ProfileViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/5/25.
//

import UIKit
import RxSwift
import RxCocoa

struct ProfileButton {
    var profileImage: String
    var name: String
    var description: String
}

struct NickName {
    enum NickNameType: String {
        case nilText = ""
        case success = "사용가능한 닉네임입니다"
        case notCount = "최소 2자, 15자 이내로 설정해 주세요"
        case notSpecial = "닉네임에는 @, #, $, %를 사용할 수 없습니다"
        case notNumeric = "닉네임에는 숫자를 포함할 수 없습니다."
    }
    
    func checkNickName(_ text: String?) -> NickNameType {
        guard let text, !text.isEmpty else { return .nilText }
        if ((text.count < 2) || (text.count >= 15)) {
            return NickNameType.notCount
        }
        if (text.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) != nil) {
            return NickNameType.notSpecial
        }
        if (text.rangeOfCharacter(from: .decimalDigits) != nil) {
            return NickNameType.notNumeric
        }
        return NickNameType.success
    }
}

final class ProfileViewModel: BaseViewModel {
    private let db: UserRepositoryType = RealmUserRepository.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let configureViewTrigger: PublishSubject<Void>
        let nameTextFieldTrigger: PublishSubject<String?>
        let successButtonTrigger: PublishSubject<ProfileButton>
        let buttonEnabledTrigger: PublishSubject<ProfileButton>
    }
    
    struct Output {
        let buttonEnabledResult: Driver<Bool?>
        let successButtonResult: Driver<Bool?>
        let nameTextFieldResult: Driver<String?>
        let configureViewResult: Driver<UserInfo?>
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension ProfileViewModel {
    
    func transform(_ input: Input) -> Output {
        let configureResult = PublishSubject<UserInfo?>()
        input.configureViewTrigger
            .bind(with: self) { owner, _ in
                configureResult.onNext(owner.db.getUserInfo())
            }.disposed(by: disposeBag)
        
        let successResult = PublishSubject<Bool?>()
        input.successButtonTrigger
            .bind(with: self) { owner, success in
                if let value = owner.handleSuccessButtonTap(profileImage: success.profileImage, name: success.name, description: success.description) {
                    successResult.onNext(owner.validateText(value, true))
                }
            }.disposed(by: disposeBag)
        
        let nameResult = PublishSubject<String?>()
        input.nameTextFieldTrigger
            .bind(with: self) { owner, text in
                let nicknameText = NickName().checkNickName(text)
                nameResult.onNext(nicknameText.rawValue)
            }.disposed(by: disposeBag)
        
        let buttonResult = PublishSubject<Bool?>()
        input.buttonEnabledTrigger
            .bind(with: self) { owner, enable in
                if let value = owner.handleSuccessButtonTap(profileImage: enable.profileImage, name: enable.name, description: enable.description)
                {
                    buttonResult.onNext(owner.validateText(value, false))
                }
            }.disposed(by: disposeBag)
        
        return Output(
            buttonEnabledResult: buttonResult.asDriver(onErrorJustReturn: nil),
            successButtonResult: successResult.asDriver(onErrorJustReturn: nil),
            nameTextFieldResult: nameResult.asDriver(onErrorJustReturn: nil),
            configureViewResult: configureResult.asDriver(onErrorJustReturn: nil)
        )
    }
    
}

extension ProfileViewModel {
    
    private func validateText(_ success: ProfileButton,_ complete: Bool) -> Bool? {
        if success.description == NickName.NickNameType.success.rawValue {
            if complete {
                db.saveUserInfo(UserInfo(name: success.name, image: success.profileImage))
            }
            return true
        } else {
            return false
        }
    }
    
    private func handleSuccessButtonTap(profileImage: String, name: String, description: String) -> ProfileButton? {
        let profileData = ProfileButton(
            profileImage: profileImage,
            name: name,
            description: description
        )
        return profileData
    }
}
