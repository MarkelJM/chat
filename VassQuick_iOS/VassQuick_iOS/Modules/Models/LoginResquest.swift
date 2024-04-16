//
//  LoginResquest.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 6/3/24.
//

import Foundation

struct LoginRequest: Codable {
    let password: String
    let login: String
    let platform: String?
    let firebaseToken: String?
}

struct LoginResponse: Codable {
    let token: String
    let user: User
}
