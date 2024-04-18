//
//  ContactListDataManager.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 11/3/24.
//

import Combine
import Foundation

class ContactListDataManager {
    
    // MARK: - Properties
    let apiClient: ContactListApiClientManager
    let chatApiClient: ChatListApiClient
    var users: [User] = []
    
    // MARK: - Init
    init(apiClient: ContactListApiClientManager, chatApiClient: ChatListApiClient) {
        self.apiClient = apiClient
        self.chatApiClient = chatApiClient
    }
    
    // MARK: - Methods
    func getUsers() -> AnyPublisher<[User], BaseError> {
        return apiClient.getUsers()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] users in
                self?.users = users
            })
            .mapError { _ in BaseError.network(description: "Error al obtener usuarios") }
            .eraseToAnyPublisher()
    }
    
    func createChat(sourceId: String, targetId: String) -> AnyPublisher<PostChats, BaseError> {
        return apiClient.createChat(sourceId: sourceId, targetId: targetId)
    }
    
    func getCurrentUserId() -> String? {
        return self.users.first?.id
    }
    
    func getCurrentUserId() -> AnyPublisher<String, BaseError> {
        chatApiClient.getCurrentUserProfile()
            .map { $0.id }
            .mapError { _ in BaseError.network(description: "Error al obtener el perfil del usuario actual") }
            .eraseToAnyPublisher()
    }
    
    func getChatIdWithUser(targetId: String) -> AnyPublisher<String, BaseError> {
        print("Fetching chat ID with targetId: \(targetId)")
        return getCurrentUserId()
            .flatMap { currentUserId in
                self.chatApiClient.getViewedChats()
                    .map { viewedChats -> String? in
                        // Busca el ID del chat entre el usuario actual y el usuario objetivo.
                        let chatId = viewedChats.first { chatView in
                            (chatView.source == currentUserId && chatView.target == targetId) ||
                            (chatView.target == currentUserId && chatView.source == targetId)
                        }?.chat
                        print("Found existing chat ID: \(String(describing: chatId))")
                        return chatId
                    }
            }
            .compactMap { $0 }
            .mapError { error in
                print("Error fetching chat ID: \(error.localizedDescription)")
                return BaseError.generic
            }
            .eraseToAnyPublisher()
    }
}
