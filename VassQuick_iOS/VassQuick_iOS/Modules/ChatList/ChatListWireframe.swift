//
//  ChatListWireframe.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 12/3/24.
//

import UIKit

class ChatListWireframe {
    
    // MARK: - Public methods
    var viewController: ChatListViewController {
        
        let viewController = ChatListViewController()
        let chatApiClient = ChatListApiClient()
        let apiClient = ApiClientManager()

        
        let dataManager: ChatListDataManager = createDataManager(with: chatApiClient, apiClient: apiClient)
        let viewModel: ChatListViewModel = createViewModel(with: dataManager)
        
        viewController.set(viewModel: viewModel)
        return viewController
    }
    
    // MARK: - Private methods
    private func createDataManager(with chatApiClient: ChatListApiClient, apiClient: ApiClientManager) -> ChatListDataManager {
        ChatListDataManager(chatApiClient: chatApiClient, apiClient: apiClient)
    }
    
    private func createViewModel(with dataManager: ChatListDataManager) -> ChatListViewModel {
        ChatListViewModel(dataManager: dataManager)
    }
    
    func push(navigation: UINavigationController? ) {
        
        guard let navigation = navigation else { return }
        navigation.pushViewController(viewController, animated: true)
    }
}
