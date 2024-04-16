//
//  LoginDataManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 7/3/24.
//

import Foundation
import Combine

class LoginDataManager {
    // MARK: - Properties
    private let apiClient: ApiClientLoginManager
    
    // MARK: - Init
    init(apiClient: ApiClientLoginManager) {
        self.apiClient = apiClient
    }

    // MARK: - Public methods
    func loginUser(loginRequest: LoginRequest) -> AnyPublisher<LoginResponse, BaseError> {
        apiClient.loginUser(body: loginRequest)
            .mapError { error -> BaseError in
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        return .noInternetConnection
                    case .timedOut:
                        return .network(description: "La solicitud ha tardado demasiado en responder.")
                    default:
                        return .network(description: "Error de red.")
                    }
                }
                return .generic
            }
            .eraseToAnyPublisher()
    }
    
    func getBiometriAuth() -> AnyPublisher<LoginResponse, BaseError> {
        apiClient.biometriAuth()
            .mapError { error -> BaseError in
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        return .noInternetConnection
                    case .timedOut:
                        return .network(description: "Error de conexión durante la autenticación biométrica.")
                    default:
                        return .network(description: "Error de red durante la autenticación biométrica.")
                    }
                }
                return .generic
            }
            .eraseToAnyPublisher()
    }

    func saveUsername(_ username: String?) {
        UserDefaults.standard.set(username, forKey: "savedUsername")
    }

    func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: "savedUsername")
    }

    func removeUsername() {
        UserDefaults.standard.removeObject(forKey: "savedUsername")
    }

    func setRememberUser(_ remember: Bool) {
        UserDefaults.standard.set(remember, forKey: "rememberUser")
    }

    func getRememberUser() -> Bool {
        return UserDefaults.standard.bool(forKey: "rememberUser")
    }

    func setBiometricEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "isBiometricEnabled")
    }

    func getBiometricEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isBiometricEnabled")
    }
    
    func saveCurrentUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: "currentUserId")
    }

    func removeCurrentUserId() {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
    }
    
}
