//
//  ChatListViewModel.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 12/3/24.
//

import Combine
import Foundation

class ChatListViewModel {
    // MARK: - Properties
    private var dataManager: ChatListDataManager
    private var cancellables = Set<AnyCancellable>()
    private var currentFilter: String = ""
    var allChats: [ChatView] = [] {
        didSet {
            filterChats(by: currentFilter)
        }
    }
    
    @Published var currentUserId: String?
    @Published var filteredChats: [ChatView] = []

    var refreshTrigger = PassthroughSubject<Void, Never>()

    // MARK: - Init
    init(dataManager: ChatListDataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - Methods
    func filterChats(by searchText: String) {
        currentFilter = searchText.lowercased()
        filteredChats = searchText.isEmpty ? allChats : allChats.filter {
            $0.sourcenick.lowercased().contains(currentFilter) ||
            $0.targetnick.lowercased().contains(currentFilter)
        }
    }
    
    func fetchCurrentUserProfile() {
        dataManager.getCurrentUserProfile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    let numberOfChats = self?.allChats.count
                    print("Error fetching current user profile: \(error) Number of chats: \(numberOfChats ?? 0)")
                }
            }, receiveValue: { [weak self] user in
                self?.currentUserId = user.id
                self?.fetchViewedChats()
            })
            .store(in: &cancellables)
    }
    
    func activateRefreshTrigger() {
        refreshTrigger
            .sink { [weak self] _ in
                self?.fetchViewedChats()
            }
            .store(in: &cancellables)
    }
    
    func logOut() {
        dataManager.logOut()
        dataManager.removeCurrentUserId()
    }
    
    func deleteChat(chatID: String) {
        dataManager.deleteChat(chatID: chatID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    let numberOfChats = self?.allChats.count
                    print("Error deleting chat: \(error). Number of chats: \(numberOfChats ?? 0)")
                }
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)
    }

    private func fetchViewedChats() {
        dataManager.getViewedChats()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    let numberOfChats = self?.allChats.count
                    print("Error fetching viewed chats: \(error). Number of chats: \(numberOfChats ?? 0)")
                    
                }
            }, receiveValue: { [weak self] chatViews in
                self?.allChats = chatViews
            })
            .store(in: &cancellables)
    }
    
    func getLastMessageForChat(chatID: String, completion: @escaping (Result<MessageListResponse, BaseError>) -> Void) {
        let cancellable = self.dataManager.getLastMessageInfo(chatID: chatID)
            .sink(receiveCompletion: { completionStatus in
                if case let .failure(error) = completionStatus {
                    completion(.failure(error))
                }
            }, receiveValue: { messageListResponse in
                completion(.success(messageListResponse))
            })

        self.cancellables.insert(cancellable)
    }

}
