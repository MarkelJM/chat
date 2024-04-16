//
//  ContactListWireframe.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 11/3/24.
//

import UIKit

class ContactListWireframe {
    
    // MARK: - Public methods
    var viewController: ContactListViewController {
        
        let viewController = ContactListViewController()
        
        let apiClient = ContactListApiClientManager()
        let chatApiClient = ChatListApiClient()
        
        let dataManager: ContactListDataManager = createDataManager(with: apiClient, chatApiCliente: chatApiClient)
        let viewModel: ContactListViewModel = createViewModel(with: dataManager)
        
        viewController.set(viewModel: viewModel)
        return viewController
    }
    
    // MARK: - Private methods
    private func createDataManager(with apiClient: ContactListApiClientManager, chatApiCliente: ChatListApiClient) -> ContactListDataManager {
        ContactListDataManager(apiClient: apiClient, chatApiClient: chatApiCliente)
    }
    
    private func createViewModel(with dataManager: ContactListDataManager) -> ContactListViewModel {
        ContactListViewModel(dataManager: dataManager)
    }
    
    func push(navigation: UINavigationController? ) {
        
        guard let navigation = navigation else { return }
        navigation.pushViewController(viewController, animated: true)
    }
}
