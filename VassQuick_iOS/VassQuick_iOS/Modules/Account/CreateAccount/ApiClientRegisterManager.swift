//
//  ApiClientRegisterManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 12/3/24.
//

import Foundation
import Alamofire
import Combine
import UIKit

class ApiClientRegisterManager: ApiClientManager {
    func registerUser(body: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, BaseError> {
        guard let parameters = try? body.toDictionary() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let relativePath = "/api/users/register"

        return requestPublisher(relativePath: relativePath, method: .post, parameters: parameters, urlEncoding: JSONEncoding.default, type: UserRegisterResponse.self)
    }
}
