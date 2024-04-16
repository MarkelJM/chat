//
//  UserRegister.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 6/3/24.
//

import Foundation

struct UserRegisterRequest: Codable {
    let login: String
    let password: String
    var nick: String
    var platform: String
    let firebaseToken: String
}

struct UserRegisterResponse: Codable {
    let token: String
    var user: User
}
