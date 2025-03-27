//
//  ChatResponseDTO.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation

struct ChatResponseDTO: Decodable {
    let choices: [ChatChoiceDTO]
    
    struct ChatChoiceDTO: Decodable {
        let message: ChatMessageDTO
    }
    struct ChatMessageDTO: Decodable {
        let content: String
    }
}
