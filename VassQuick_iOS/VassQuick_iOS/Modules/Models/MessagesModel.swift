//
//  MessagesModel.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 7/3/24.
//

import Foundation

// MARK: - PostMessageNew
struct MessageNewResponse: Codable {
    let success: Bool
}

// MARK: - MessageList
struct MessageListResponse: Codable {
    let count: Int
    let rows: [MessageListModel]
}

// MARK: - Row
struct MessageListModel: Codable {
    let id, chat, source, message: String
    let date: String
}
