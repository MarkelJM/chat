//
//  CreateAccountSwiftUIViewModel.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 8/3/24.
//

import UIKit
import Combine
import SwiftUI

class CreateAccountSwiftUIViewModel: ObservableObject {
    
    // MARK: - Properties
    private var dataManager: CreateAccountSwiftUIDataManager
    private var apiClient: ApiClientManager = ApiClientManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var didTapLogin = PassthroughSubject<Void, Never>()
    @Published var nick: String = ""
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
        
    // MARK: - Init
    init(dataManager: CreateAccountSwiftUIDataManager) {
        self.dataManager = dataManager
    }
    
    var isSignedButtonEnable: Bool {
        return !nick.isEmpty && !login.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && (password.count >= 6) && (password == confirmPassword)
    }
    
    func registerUser() {
        
        let body = UserRegisterRequest(login: login, password: password, nick: nick, platform: "iOS", firebaseToken: "")

        dataManager.registerUser(registerRequest: body)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error en el registro: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] registerResponse in
                KeyChainManager.shared.save(token: registerResponse.token)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    func createAccount() {
        guard isSignedButtonEnable else {
            return
        }
        registerUser()
    }
}
