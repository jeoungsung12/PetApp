//
//  PetAppWidget.swift
//  PetAppWidget
//
//  Created by 정성윤 on 4/22/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    //위젯 최초 렌더링
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            name: "푸들",
            shelter: "한국유기동물보호소",
            image: "",
            endDate: "공고마감 7일전!"
        )
    }
    
    //위젯 갤러리 미리보기 화면
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            name: "푸들",
            shelter: "한국유기동물보호소",
            image: "",
            endDate: "공고마감 7일전!"
        )
        completion(entry)
    }
    
    //위젯 상태 변경 시점
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: Date(),
                name: "푸들",
                shelter: "한국유기동물보호소",
                image: "",
                endDate: "공고마감 7일전!"
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let shelter: String
    let image: String
    let endDate: String
}

struct PetAppWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("")
//        VStack(alignment: .center, spacing: 12) {
//            HStack(alignment: .center, spacing: 12) {
//                PosterView(image: entry.image, size: 70)
//                    .frame(height: 70)
//                    .scaledToFill()
//                    .background(.gray.opacity(0.3))
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(entry.name)
//                        .font(.callout)
//                        .bold()
//                        .asForeground(.black)
//                    
//                    Text(entry.shelter)
//                        .font(.caption)
//                        .asForeground(.black)
//                    
////                    Spacer()
//                }
//            }
//            .padding(.top, 4)
//            .padding(.horizontal, 4)
//            
//            Spacer()
//            
//            HStack {
//                Spacer()
//                Text(entry.endDate)
//                    .padding(5)
//                    .background(.pink.opacity(0.7))
//                    .asForeground(.white)
//                    .font(.caption)
//                    .bold()
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//            }
//            .padding(.horizontal, 4)
//        }
    }
}

struct PetAppWidget: Widget {
    let kind: String = "PetAppWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PetAppWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PetAppWidgetEntryView(entry: entry)
                    .padding()
//                    .background()
            }
        }
        .configurationDisplayName("Warala 위젯")
        .description("와랄라 위젯 예시 화면입니다.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//#Preview(as: .systemSmall) {
//    PetAppWidget()
//} timeline: {
//    SimpleEntry(
//        date: Date(),
//        name: "푸들",
//        shelter: "한국유기동물보호소",
//        image: "",
//        endDate: "공고마감 7일전!"
//    )
//}
