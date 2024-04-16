//
//  MessageListDataManager.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 18/3/24.
//

import Combine
import Foundation

class MessageListDataManager {
    
    // MARK: - Public properties
    var messages: [MessageListModel] = []
    var messageCount: Int = 0
    
    // MARK: - Properties
    var apiClient: MessageListApiClient
    
    // MARK: - Init
    init(apiClient: MessageListApiClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - Methods
    func getMessagesList(chatID: String) -> AnyPublisher<(Int, [MessageListModel]), BaseError> {
        print("MessageListDataManager - getMessagesList - ChatID recibido: \(chatID)")
        
        return apiClient.getMessagesList(chatID: chatID)
            .receive(on: DispatchQueue.main)
            .map { response in
                return (response.count, response.rows)
            }
            .mapError { _ in BaseError.network(description: "Error al obtener mensajes") }
            .eraseToAnyPublisher()
    }
    
    func loadOlderMessages(chatID: String, offset: Int, limit: Int) -> AnyPublisher<(Int, [MessageListModel]), BaseError> {
        print("MessageListDataManager - loadOlderMessages - ChatID recibido: \(chatID)")
        
        return apiClient.getMessagesList(chatID: chatID, offset: offset, limit: limit)
            .receive(on: DispatchQueue.main)
            .map { response in
                return (response.count, response.rows)
            }
            .mapError { _ in BaseError.network(description: "Error al obtener mensajes antiguos") }
            .eraseToAnyPublisher()
    }
    
    func getCurrentUserId() -> String? {
        UserDefaults.standard.string(forKey: "currentUserId")
    }
    
    func postNewMessage(chatID: String, sourceID: String, message: String) -> AnyPublisher<MessageNewResponse, BaseError> {
        apiClient.postNewMessage(chatID: chatID, sourceID: sourceID, message: message)
    }
}
