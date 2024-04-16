//
//  MessageListWireframe.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 18/3/24.
//

import UIKit

class MessageListWireframe {
    
    // MARK: - Public methods
    var viewController: MessageListViewController {
        
        let viewController = MessageListViewController()
        let apiClient = MessageListApiClient()
        
        let dataManager: MessageListDataManager = createDataManager(with: apiClient)
        let viewModel: MessageListViewModel = createViewModel(with: dataManager)
        
        viewController.set(viewModel: viewModel)
        return viewController
    }
    
    // MARK: - Private methods
    private func createDataManager(with apiClient: MessageListApiClient) -> MessageListDataManager {
        MessageListDataManager(apiClient: apiClient)
    }
    
    private func createViewModel(with dataManager: MessageListDataManager) -> MessageListViewModel {
        MessageListViewModel(dataManager: dataManager)
    }
    
    func push(navigation: UINavigationController?, withChatView chatView: ChatView? = nil, withUser user: User? = nil) {
        let viewController = self.viewController
        viewController.chat = chatView
        viewController.user = user
        
        guard let navigation = navigation else { return }
        navigation.pushViewController(viewController, animated: true)
    }
}
