//
//  ChatsModel.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 7/3/24.
//

import Foundation

// MARK: - PostChats
struct PostChats: Codable {
    let success, created: Bool
    let chat: Chat
}

// MARK: - Chat
struct Chat: Codable {
    let id, source, target, created: String
}

// MARK: - ChatView
struct ChatView: Codable {
    let chat, source, sourcenick, sourceavatar: String
    let sourceonline: Bool
    let sourcetoken: String?
    let target, targetnick, targetavatar: String
    let targetonline: Bool
    let targettoken: String?
    let chatcreated: String
    
    init(chat: Chat) {
        self.chat = chat.id
        self.source = chat.source
        self.sourcenick = ""
        self.sourceavatar = ""
        self.sourceonline = false
        self.sourcetoken = ""
        self.target = chat.target
        self.targetnick = ""
        self.targetavatar = ""
        self.targetonline = false
        self.targettoken = ""
        self.chatcreated = chat.created
    }
}
