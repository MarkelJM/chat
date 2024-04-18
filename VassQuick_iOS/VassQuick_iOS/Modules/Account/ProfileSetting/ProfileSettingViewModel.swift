//
//  ProfileSettingViewModel.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 19/3/24.
//

import Foundation
import SwiftUI
import Combine

class ProfileSettingViewModel: ObservableObject {
    @Published var user: User?
    @Published var isBiometricEnabled: Bool = UserDefaults.standard.bool(forKey: "isBiometricEnabled") {
        didSet {
            UserDefaults.standard.set(isBiometricEnabled, forKey: "isBiometricEnabled")
        }
    }
    @Published var selectedImage: UIImage?
    @Published var showPassword: Bool = false
    @Published var password: String = ""
    @Published var nick: String = ""

    private let dataManager: ProfileDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: ProfileDataManager) {
        self.dataManager = dataManager
        getUserProfile()
    }
    
    func getUserProfile() {
        guard let token = KeyChainManager.shared.getToken() else {
            return
        }
        
        dataManager.getUserProfile(token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { user in
                self.user = user
            })
            .store(in: &cancellables)
    }
    
    func updateUserProfile() {
        guard let token = KeyChainManager.shared.getToken() else {
            print("No token available")
            return
        }
        
        let newNick = nick.isEmpty ? user?.nick : nick // Si esta vacio el campo usamos el del comienzo
        let newPassword = password.isEmpty ? user?.password : password
        
        let updateRequest = UserUpdateRequest(password: newPassword ?? "", nick: newNick ?? "")
        dataManager.updateUserProfile(updateRequest: updateRequest, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error updating profile: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                print("Profile updated successfully.")
                self?.getUserProfile()
            })
            .store(in: &cancellables)
    }

    func uploadSelectedImage() {
        guard let selectedImage = selectedImage,
              let token = KeyChainManager.shared.getToken() else {
            print("No se seleccionó imagen o falta token")
            return
        }

        let imageName = UUID().uuidString
        dataManager.uploadImage(image: selectedImage, imageName: imageName, token: token)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error uploading image: \(error.localizedDescription)")
                case .finished:
                    print("Image uploaded successfully.")
                }
            }, receiveValue: { [weak self] response in
                let urlInMessage = response.message 
                self?.user?.avatar = urlInMessage
                self?.selectedImage = selectedImage
                print("Upload response: \(response.message)")
            })
            .store(in: &cancellables)
    }

    private func updateUserAvatar(with urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        self?.user?.avatar = urlString
                        self?.selectedImage = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
