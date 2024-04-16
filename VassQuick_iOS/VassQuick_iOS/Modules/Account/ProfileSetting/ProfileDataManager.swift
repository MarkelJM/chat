//
//  ProfileDataManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 18/3/24.
//

import Foundation
import Combine
import UIKit

class ProfileDataManager {
    private let apiClient: ApiClientSettingManager
    
    init(apiClient: ApiClientSettingManager) {
        self.apiClient = apiClient
    }
    
    func getUserProfile(token: String) -> AnyPublisher<User, BaseError> {
        return apiClient.getUserProfile()
    }
    
    func updateUserProfile(updateRequest: UserUpdateRequest, token: String) -> AnyPublisher<UserUpdateResponse, BaseError> {
        return apiClient.updateUserProfile(body: updateRequest)
    }
    
    func uploadImage(image: UIImage, imageName: String, token: String) -> AnyPublisher<ImageUploadResponse, BaseError> {
        apiClient.uploadImage(image: image, imageName: imageName, token: token)
    }
    
    func setBiometricAuth(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "isBiometricEnabled")
    }
    
    func isBiometricAuthEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isBiometricEnabled")
    }

}
