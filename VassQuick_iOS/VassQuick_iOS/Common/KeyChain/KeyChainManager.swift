//
//  SecureDataProvider.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 7/3/24.
//

import Foundation
import KeychainSwift

protocol KeyChainManagerProtocol {
    func save(token: String)
    func getToken() -> String?
    func deleteToken()
}

final class KeyChainManager: KeyChainManagerProtocol {
    static let shared = KeyChainManager() 
    private let keychain = KeychainSwift()

    private enum Key {
        static let token = "Token"
    }
    
    private init() {}

    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }

    func getToken() -> String? {
        keychain.get(Key.token)
    }
    
    func deleteToken() {
        keychain.delete(Key.token)
    }
}
