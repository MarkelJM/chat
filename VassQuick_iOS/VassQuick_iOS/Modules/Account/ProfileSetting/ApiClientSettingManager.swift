//
//  ApiClientSettingManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 18/3/24.
//

import Foundation
import UIKit
import Combine
import Alamofire

class ApiClientSettingManager: ApiClientManager {
    func getUserProfile() -> AnyPublisher<User, BaseError> {
        
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let relativePath = "/api/users/profile"
        let headers: HTTPHeaders = ["Authorization": token]
        
        return requestPublisher(relativePath: relativePath,
                                method: .get,
                                urlEncoding: URLEncoding.default,
                                type: User.self,
                                customHeaders: headers)
    }
    
    func updateUserProfile(body: UserUpdateRequest) -> AnyPublisher<UserUpdateResponse, BaseError> {
        
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        guard let parameters = try? body.toDictionary() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }

        let relativePath = "/api/users/profile"
        let headers: HTTPHeaders = ["Authorization": token]
        
        return requestPublisher(relativePath: relativePath,
                                method: .put,
                                parameters: parameters,
                                urlEncoding: JSONEncoding.default,
                                type: UserUpdateResponse.self,
                                customHeaders: headers)
    }
}
