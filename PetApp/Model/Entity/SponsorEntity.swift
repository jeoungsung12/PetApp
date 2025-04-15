//
//  SponsorEntity.swift
//  PetApp
//
//  Created by 정성윤 on 4/15/25.
//

import Foundation
struct SponsorEntity {
    let image: String
    let title: String
    let siteURL: String
}

let SponsorData: [SponsorEntity] = [
    SponsorEntity(image: "sponsor1", title: "동물자유연대", siteURL: "https://www.animals.or.kr/support/intro"),
    SponsorEntity(image: "sponsor2", title: "동물권행동카라", siteURL: "https://ekara.org/support/introduce"),
    SponsorEntity(image: "sponsor3", title: "종합유기견보호센터", siteURL: "https://www.zooseyo.or.kr/Yu_board/volunteer_listD.php"),
    SponsorEntity(image: "sponsor4", title: "동물보호단체라이프", siteURL: "http://www.savelife.or.kr/sponsor04.asp"),
    SponsorEntity(image: "sponsor5", title: "한국유기동물복지협회", siteURL: "https://www.ihappynanum.com/Nanum/B/PJUP9WNSGK"),
    SponsorEntity(image: "sponsor6", title: "토스뱅크겨울나기캠페인", siteURL: "https://www.tossbank.com/articles/32483"),
    SponsorEntity(image: "sponsor7", title: "동물권단체케어", siteURL: "https://animalrights.or.kr/pages/support-guide.php"),
    SponsorEntity(image: "sponsor8", title: "한국동물보호협회", siteURL: "http://koreananimals.or.kr/contribution")
]
