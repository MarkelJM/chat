//
//  CreateAccountSwiftUIDataManager.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 8/3/24.
//

import Foundation
import Combine

class CreateAccountSwiftUIDataManager {
    // MARK: - Properties
    private let apiClient: ApiClientRegisterManager
    
    // MARK: - Init
    init(apiClient: ApiClientRegisterManager) {
        self.apiClient = apiClient
    }
        
    // MARK: - Methods
    func registerUser(registerRequest: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, BaseError> {
        return apiClient.registerUser(body: registerRequest)
    }
}
