//
//  ContactListViewModel.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 13/3/24.
//

import Combine
import Foundation

class ContactListViewModel {
    // MARK: - Properties
    @Published var filteredUsers: [User] = []
    @Published var chatCreated: [Chat] = []

    var chatID: String = ""
    var targetID = ""
    var refreshTrigger = PassthroughSubject<Void, Never>()
    var allUsers: [User] = [] {
        didSet {
            filterUsers(by: currentFilter)
        }
    }
    
    private var currentFilter: String = ""
    private var cancellables = Set<AnyCancellable>()
    private(set) var currentUserId: String?
    
    let navigateToChatPublisher = PassthroughSubject<(ChatView, User), Never>()
    let dataManager: ContactListDataManager

    // MARK: - Init
    init(dataManager: ContactListDataManager) {
        self.dataManager = dataManager
        bindCurrentUserProfileAndFetchUsers()
    }
        
    // MARK: - Methods
    func bindCurrentUserProfileAndFetchUsers() {
        dataManager.getCurrentUserId()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching current user ID: \(error.localizedDescription)")
                case .finished:
                    self?.fetchUsers()
                }
            }, receiveValue: { [weak self] userId in
                print("Current User ID: \(userId)")
                self?.currentUserId = userId
            })
            .store(in: &cancellables)
    }
    
    func fetchUsers() {
        dataManager.getUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Error fetching users: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] users in
                self?.allUsers = users
            })
            .store(in: &cancellables)
    }
    
    func filterUsers(by searchText: String) {
        currentFilter = searchText
        filteredUsers = searchText.isEmpty ? allUsers : allUsers.filter { user in
            user.login?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    func activateRefreshTrigger() {
        refreshTrigger
            .sink { [weak self] _ in
                self?.fetchUsers()
            }
            .store(in: &cancellables)
    }
    
    func handleChatSelection(for user: User) {
        
        let targetId = user.id
        
        dataManager.createChat(sourceId: currentUserId ?? "", targetId: targetId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error creating chat: \(error.localizedDescription)")
                case .finished:
                    print("Chat creation finished.")
                }
            }, receiveValue: { [weak self] postChats in
                if postChats.success {
                    let chatView = ChatView(chat: postChats.chat)
                    self?.chatID = postChats.chat.id
                    self?.navigateToChatPublisher.send((chatView, user))
                } else {
                    print("Error: Chat creation failed")
                }
            })
            .store(in: &cancellables)
    }
}
