//
//  ChatEntity.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation

struct ChatEntity {
    let type: ChatType
    let name: String
    let message: String
    let thumbImage: String
}
//
//extension ChatResponseDTO {
//    func toEntity() -> ChatResponseEntity {
//        return ChatResponseEntity(content: self.choices.first?.message.content ?? "")
//    }
//}
