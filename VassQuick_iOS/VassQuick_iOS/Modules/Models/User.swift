//
//  User.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 6/3/24.
//

import Foundation

struct User: Codable {
    let id: String
    let login: String?
    var password: String?
    var nick: String?
    var platform: String?
    var avatar: String?
    let uuid: String?
    let token: String?
    var online: Bool?
    let created: String?
    var updated: String?
}

struct UserUpdateRequest: Codable {
    let password: String
    let nick: String
}

struct UserUpdateResponse: Codable {
    let success: Bool
}
