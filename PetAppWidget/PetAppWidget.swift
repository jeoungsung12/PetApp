//
//  PetAppWidget.swift
//  PetAppWidget
//
//  Created by 정성윤 on 4/22/25.
//

import WidgetKit
import SwiftUI
import SNKit

extension UserDefaults {
    static var groupShared: UserDefaults {
        let appGroupID = "group.Warala.SeSAC"
        return UserDefaults(suiteName: appGroupID)!
    }
}

struct Provider: TimelineProvider {
    // 날짜 계산 함수 - 공고 마감일까지 남은 일수 계산
    private func calculateDaysLeft(endDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        guard let endDate = dateFormatter.date(from: endDateString) else {
            return "정보 없음"
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
        
        if let days = components.day {
            if days <= 0 {
                return "공고 마감"
            } else {
                return "공고마감 \(days)일전!"
            }
        }
        
        return "정보 없음"
    }
    
    //위젯 최초 렌더링
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            id: "",
            name: "관심등록하면 볼 수 있어요",
            shelter: "지금 등록해 보세요!",
            image: "",
            endDate: "유기동물을 도와주세요"
        )
    }
    
    //위젯 갤러리 미리보기 화면
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let likedPets = getLikedPets()
        
        if let firstPet = likedPets.first {
            let entry = SimpleEntry(
                date: Date(),
                id: firstPet["id"] ?? "",
                name: firstPet["name"] ?? "이름 정보 없음",
                shelter: firstPet["shelter"] ?? "보호소 정보 없음",
                image: firstPet["image"] ?? "",
                endDate: calculateDaysLeft(endDateString: firstPet["endDate"] ?? "")
            )
            completion(entry)
        } else {
            let entry = SimpleEntry(
                date: Date(),
                id: "",
                name: "관심등록하면 볼 수 있어요",
                shelter: "지금 등록해 보세요!",
                image: "",
                endDate: "유기동물을 도와주세요"
            )
            completion(entry)
        }
    }
    
    //위젯 상태 변경 시점
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let likedPets = getLikedPets()
        
        if likedPets.isEmpty {
            let entry = SimpleEntry(
                date: Date(),
                id: "",
                name: "관심등록하면 볼 수 있어요",
                shelter: "지금 등록해 보세요!",
                image: "",
                endDate: "유기동물을 도와주세요"
            )
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
            return
        }
        
        let currentDate = Date()
        for hourOffset in 0 ..< max(1, likedPets.count) {
            let petIndex = hourOffset % likedPets.count
            let pet = likedPets[petIndex]
            
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset * 10, to: currentDate)!
            
            let entry = SimpleEntry(
                date: entryDate,
                id: pet["id"] ?? "",
                name: pet["name"] ?? "이름 정보 없음",
                shelter: pet["shelter"] ?? "보호소 정보 없음",
                image: pet["image"] ?? "",
                endDate: calculateDaysLeft(endDateString: pet["endDate"] ?? "")
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getLikedPets() -> [[String: String]] {
        guard let petsData = UserDefaults.groupShared.array(forKey: "likedPetsKey") as? [[String: String]] else {
            return []
        }
        
        let validPets = petsData.filter { pet in
            guard let endDateString = pet["endDate"],
                  !endDateString.isEmpty else {
                return false
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            guard let endDate = dateFormatter.date(from: endDateString) else {
                return false
            }
            
            return endDate >= Date()
        }
        return validPets
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let id: String
    let name: String
    let shelter: String
    let image: String
    let endDate: String
}

struct PetAppWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let imageURL = URL(string: entry.image), imageURL.isFileURL,
                   let uiImage = UIImage(contentsOfFile: imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Color.gray.opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.name)
                                .font(.system(size: 13, weight: .heavy))
                                .shadow(color: .black, radius: 2)
                            
                            Text(entry.shelter)
                                .font(.system(size: 11, weight: .bold))
                                .shadow(color: .black, radius: 2)
                        }
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
                    .padding(.horizontal, 8)
                        

                    Spacer()

                    HStack {
                        Text(entry.endDate)
                            .padding(5)
                            .background(Color.pink.opacity(0.7))
                            .foregroundColor(.white)
                            .font(.system(size: 11, weight: .bold))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }


}

struct PetAppWidget: Widget {
    let kind: String = "PetAppWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PetAppWidgetEntryView(entry: entry)
                    .containerBackground(.white, for: .widget)
            } else {
                PetAppWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color.white)
            }
        }
        .configurationDisplayName("Warala 위젯")
        .description("와랄라 위젯 예시 화면입니다.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PetAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        PetAppWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            id: "",
            name: "푸들",
            shelter: "한국유기동물보호소",
            image: "",
            endDate: "공고마감 7일전!"
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
