//
//  ApiClientLoginManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 12/3/24.
//

import Foundation
import Combine
import Alamofire

class ApiClientLoginManager: ApiClientManager {
    
    func loginUser(body: LoginRequest) -> AnyPublisher<LoginResponse, BaseError> {
        guard let parameters = try? body.toDictionary() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }

        let relativePath = "/api/users/login"

        return requestPublisher(relativePath: relativePath,
                                method: .post,
                                parameters: parameters,
                                urlEncoding: JSONEncoding.default,
                                type: LoginResponse.self)
            .eraseToAnyPublisher()
    }
    
    func biometriAuth() -> AnyPublisher<LoginResponse, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let relativePath = "/api/users/biometric"
        
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        return requestPublisher(relativePath: relativePath,
                                method: .post,
                                urlEncoding: JSONEncoding.default,
                                type: LoginResponse.self, customHeaders: headers)
            .eraseToAnyPublisher()
    }
}
