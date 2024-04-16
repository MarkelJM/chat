//
//  MessageListApiClient.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 18/3/24.
//

import Alamofire
import Combine
import UIKit

class MessageListApiClient: ApiClientManager {
    
    // MARK: - Methods    
    func postNewMessage(chatID: String, sourceID: String, message: String) -> AnyPublisher<MessageNewResponse, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let relativePath = "/api/messages/new"
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters: [String: Any] = [
            "chat": chatID,
            "source": sourceID,
            "message": message
        ]
        
        print("Sending request to \(relativePath) with token \(token)")
        
        return requestPublisher(relativePath: relativePath, method: .post, parameters: parameters, urlEncoding: JSONEncoding.default, type: MessageNewResponse.self, customHeaders: headers)
    }
}
