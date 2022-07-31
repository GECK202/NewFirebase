//
//  ConversationModel.swift
//  FB
//
//  Created by Valeria Karon on 7/30/22.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
