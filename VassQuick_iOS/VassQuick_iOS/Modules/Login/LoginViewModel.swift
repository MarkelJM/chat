//
//  LoginViewModel.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 7/3/24.
//

import Foundation
import Combine

class LoginViewModel {
    // MARK: - Properties
    private let dataManager: LoginDataManager
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var isLoginButtonEnabled: Bool = false
    @Published var loginError: String?
    @Published var passwordError: String?
    
    @Published var isBiometricAuthButtonEnabled: Bool = false
    
    // MARK: - Init
    init(dataManager: LoginDataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - Public methods
    func validateFields(login: String?, password: String?) {
        let isLoginValid = !(login?.isEmpty ?? true)
        let isPasswordValid = !(password?.isEmpty ?? true)
        
        loginError = isLoginValid ? nil : "login_view_model_validation_error".localized
        passwordError = isPasswordValid ? nil : "login_view_model_validation_error_password".localized

        isLoginButtonEnabled = isLoginValid && isPasswordValid
    }
    func updateBiometricAuthButtonState() {
        let rememberUser = dataManager.getRememberUser()
        let biometricEnabled = dataManager.getBiometricEnabled()
        let hasToken = KeyChainManager.shared.getToken() != nil

        DispatchQueue.main.async {
            self.isBiometricAuthButtonEnabled = rememberUser && biometricEnabled && hasToken
        }
    }

    func loginUser(login: String, password: String) -> AnyPublisher<LoginResponse, BaseError> {
        let loginRequest = LoginRequest(password: password, login: login, platform: "iOS", firebaseToken: "...")

        return dataManager.loginUser(loginRequest: loginRequest)
            .handleEvents(receiveOutput: { [weak self] loginResponse in
                KeyChainManager.shared.save(token: loginResponse.token)
                self?.dataManager.saveCurrentUserId(loginResponse.user.id)
                if self?.dataManager.getRememberUser() != nil {
                    self?.dataManager.saveUsername(login)
                } else {
                    self?.dataManager.removeUsername()
                }
            }, receiveCompletion: { [weak self] completion in
                if case .failure: _ = completion {
                    DispatchQueue.main.async {
                        self?.loginError = "login_view_model_validation_user_error".localized
                        self?.passwordError = "login_view_model_validation_user_error".localized
                    }
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getBiometriAuth(completion: @escaping (LoginResponse) -> Void) {
        dataManager.getBiometriAuth().sink(receiveCompletion: { completionStatus in
            switch completionStatus {
            case .failure(let error):
                print("Error en la autenticación biométrica: \(error)")
            case .finished:
                break
            }
        }, receiveValue: { loginResponse in
            completion(loginResponse)
        }).store(in: &cancellables)
    }

    func handleRememberUserSwitchChanged(isOn: Bool) {
        dataManager.setRememberUser(isOn)
        if !isOn {
            dataManager.removeUsername()
        }
        updateBiometricAuthButtonState()
    }
    
    func shouldEnableBiometricButton() -> Bool {
        let isBiometricEnabled = dataManager.getBiometricEnabled()
        let rememberUser = dataManager.getRememberUser()
        let hasToken = KeyChainManager.shared.getToken() != nil
        
        return isBiometricEnabled && rememberUser && hasToken
    }
    
    func checkExistToken() -> Bool {
        guard KeyChainManager.shared.getToken() != nil else {
            return false
        }
        return true
    }
    
    func cleanErrors() {
        loginError = nil
        passwordError = nil
    }
    
    func saveUsername(_ username: String?) {
        dataManager.saveUsername(username)
    }

    func getUsername() -> String? {
        return dataManager.getUsername()
    }

    func removeUsername() {
        dataManager.removeUsername()
    }

    func setRememberUser(_ remember: Bool) {
        dataManager.setRememberUser(remember)
    }

    func getRememberUser() -> Bool {
        return dataManager.getRememberUser()
    }
    
    func removeUserId() {
         dataManager.removeCurrentUserId()
    }
}
