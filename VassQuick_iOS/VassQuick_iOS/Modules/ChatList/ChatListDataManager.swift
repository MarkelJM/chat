//
//  ChatListDataManager.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 12/3/24.
//

import Combine
import Foundation

class ChatListDataManager {

    // MARK: - Properties
    var chatApiClient: ChatListApiClient
    var apiClient: ApiClientManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(chatApiClient: ChatListApiClient, apiClient: ApiClientManager) {
        self.chatApiClient = chatApiClient
        self.apiClient = apiClient
    }
    
    // MARK: - Methods
    func getCurrentUserProfile() -> AnyPublisher<User, BaseError> {
        return chatApiClient.getCurrentUserProfile()
    }
    
    func getViewedChats() -> AnyPublisher<[ChatView], BaseError> {
        chatApiClient.getViewedChats()
    }
    
    func logOut() {
        chatApiClient.logout()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error poniendo el estado offline: \(error)")
                case .finished:
                    print("La solicitud de estado offline se completó")
                }
            }, receiveValue: { response in
                print("Respuesta de la solicitud de estado offline: \(response)")
            })
            .store(in: &cancellables)
    }
    
    func deleteChat(chatID: String) -> AnyPublisher<Void, BaseError> {
        chatApiClient.deleteChat(chatID: chatID)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func removeCurrentUserId() {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
    }
    
    func getLastMessageInfo(chatID: String) -> AnyPublisher<MessageListResponse, BaseError> {
        return apiClient.getMessagesList(chatID: chatID)
            .catch { error -> AnyPublisher<MessageListResponse, BaseError> in
                return Fail(error: BaseError.network(description: "Network error: \(error.localizedDescription)")).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
