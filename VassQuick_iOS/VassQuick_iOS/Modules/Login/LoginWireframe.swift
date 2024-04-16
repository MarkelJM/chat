//
//  LoginWireframe.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 7/3/24.
//

import UIKit

class LoginWireframe {
    
    // MARK: - Public methods
    var viewController: LoginViewController {
        
        let viewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        let apiClient = ApiClientManager()
        
        let dataManager: LoginDataManager = createDataManager(with: apiClient)
        let viewModel: LoginViewModel = createViewModel(with: dataManager)
        
        viewController.set(viewModel: viewModel)
        return viewController
    }
    
    // MARK: - Private methods
    private func createDataManager(with apiClient: ApiClientManager) -> LoginDataManager {
        LoginDataManager(apiClient: ApiClientLoginManager())
    }
    
    private func createViewModel(with dataManager: LoginDataManager) -> LoginViewModel {
        LoginViewModel(dataManager: LoginDataManager(apiClient: ApiClientLoginManager()))
    }
    
    func push(navigation: UINavigationController?) {
        guard let navigation = navigation else { return }
        navigation.pushViewController(viewController, animated: true)
    }
}
