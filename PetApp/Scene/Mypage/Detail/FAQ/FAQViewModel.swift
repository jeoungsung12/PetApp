//
//  FAQViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/23/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwift
import RxCocoa

struct FAQItem {
    let question: String
    let answer: String
}

final class FAQViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    private let faqData: [FAQItem] = [
        FAQItem(
            question: "이 앱에서 제공하는 정보는 어느 지역을 대상으로 하나요?",
            answer: "현재 이 앱은 경기권(경기도) 내의 동물보호소와 관련된 정보만 제공합니다. 보호소 위치, 보호 중인 동물 정보, 동물병원 지도 등은 모두 경기도에 한정됩니다."
        ),
        FAQItem(
            question: "보호소에서 보호 중인 동물의 정보를 어떻게 확인하나요?",
            answer: "앱 내에서 '보호 동물 정보' 메뉴를 선택하시면 경기권 동물보호소에 현재 보호 중인 동물들의 사진, 종, 나이, 성별 등의 정보를 확인할 수 있습니다."
        ),
        FAQItem(
            question: "보호소 위치와 동물병원 지도는 어떻게 보나요?",
            answer: "앱의 '지도' 기능을 통해 경기권 내 동물보호소와 동물병원의 위치를 확인할 수 있습니다. 보호소와 병원을 구분해서 표시하며, 클릭하면 상세 주소와 연락처가 제공됩니다."
        ),
        FAQItem(
            question: "보호 중인 동물의 영상은 어디서 볼 수 있나요?",
            answer: "각 동물의 상세 정보 페이지에서 보호소에서 제공한 영상을 확인할 수 있습니다. 영상은 보호소가 앱에 업로드한 경우에만 볼 수 있습니다."
        ),
        FAQItem(
            question: "봉사활동이나 일상을 기록하려면 어떻게 해야 하나요?",
            answer: "앱의 '기록' 메뉴에서 봉사활동이나 유기동물과 함께한 일상을 텍스트, 사진 등으로 업로드할 수 있습니다. 기록은 개인적으로 저장할 수 있습니다."
        ),
        FAQItem(
            question: "관심 등록은 무엇인가요?",
            answer: "관심 등록은 보호 중인 동물 중 마음에 드는 동물을 선택해 '관심 동물'로 저장하는 기능입니다. 이후 해당 동물의 상태 변화(입양 등)를 확인할 수 있습니다."
        ),
        FAQItem(
            question: "챗봇 AI는 어떤 도움을 주나요?",
            answer: "챗봇 AI는 동물의 성격을 반영해 대화하며, 유기동물에 대한 궁금증을 해결하거나 보호소 관련 정보를 안내합니다. 예를 들어, '특정 동물의 특징'이나 '입양 절차'를 물어볼 수 있습니다."
        ),
        FAQItem(
            question: "경기권 외의 지역 정보는 언제 추가되나요?",
            answer: "현재는 경기권만 서비스 중이며, 다른 지역 정보는 추후 업데이트를 통해 추가될 예정입니다. 정확한 일정은 아직 정해지지 않았습니다."
        ),
        FAQItem(
            question: "입양 절차는 어떻게 되나요?",
            answer: "입양은 각 보호소의 절차를 따르며, 앱에서 동물 상세 페이지에 있는 보호소 연락처로 문의하시면 자세한 안내를 받을 수 있습니다."
        ),
        FAQItem(
            question: "앱에서 제공하는 정보는 얼마나 자주 업데이트되나요?",
            answer: "보호소에서 제공하는 데이터를 기반으로 하며, 보호소가 정보를 업데이트할 때마다 실시간으로 반영됩니다. 영상이나 사진은 보호소의 업로드 주기에 따라 다를 수 있습니다."
        )
    ]
    
    struct Input {}
    
    struct Output {
        let data: Driver<[FAQItem]>
    }
}

extension FAQViewModel {
    
    func transform(_ input: Input) -> Output {
        let faqDriver = Driver.just(faqData)
        return Output(data: faqDriver)
    }
}
