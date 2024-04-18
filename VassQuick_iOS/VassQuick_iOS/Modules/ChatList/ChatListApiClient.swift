//
//  ChatListApiClient.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 15/3/24.
//
import Alamofire
import Combine
import Foundation

final class ChatListApiClient: ApiClientManager {
    
    // MARK: - Methods
    func getViewedChats() -> AnyPublisher<[ChatView], BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }

        let relativePath = "/api/chats/view"
        let headers: HTTPHeaders = [
            "Authorization": token
        ]

        return requestPublisher(relativePath: relativePath,
                                method: .get,
                                urlEncoding: JSONEncoding.default,
                                type: [ChatView].self,
                                customHeaders: headers)
    }
    
    func deleteChat(chatID: String) -> AnyPublisher<String, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            print("Token is nil")
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let headers = ["Authorization": token]
        
        var relativePath = "api/chats/"
        relativePath += chatID

        return requestPublisher(relativePath: relativePath,
                                method: .delete,
                                parameters: nil,
                                urlEncoding: URLEncoding.default,
                                type: String.self,
                                customHeaders: HTTPHeaders(headers))
    }
}
