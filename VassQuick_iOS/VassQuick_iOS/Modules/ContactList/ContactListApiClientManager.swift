//
//  ContactListApiClientManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 14/3/24.
//

import Alamofire
import Combine
import Foundation
import UIKit

class ContactListApiClientManager: ApiClientManager {
    
    func createChat(sourceId: String, targetId: String) -> AnyPublisher<PostChats, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let relativePath = "/api/chats"
        let parameters: Parameters = ["source": sourceId, "target": targetId]
        let customHeaders: HTTPHeaders = ["Authorization": token] 
        
        return requestPublisher(relativePath: relativePath,
                                method: .post,
                                parameters: parameters,
                                urlEncoding: JSONEncoding.default,
                                type: PostChats.self,
                                customHeaders: customHeaders)
    }
}
