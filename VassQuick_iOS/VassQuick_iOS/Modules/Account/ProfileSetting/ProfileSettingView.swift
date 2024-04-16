//
//  ProfileSettingView.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 19/3/24.
//

import SwiftUI

struct ProfileSettingView: View {
    @ObservedObject var viewModel: ProfileSettingViewModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showPassword = true
    @State private var showAlert = false
    
    var dismiss: (() -> Void)?
    var navigateBackToLogin: (() -> Void)?

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                if let avatarUrl = viewModel.user?.avatar, let url = URL(string: avatarUrl), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                }

                Text(viewModel.user?.login ?? "profile_setting_view_title".localized)
                    .font(.title)
                    .foregroundColor(.white)

                CustomTextField(text: $viewModel.nick,
                                placeholder: "profile_setting_view_placeholder_nick".localized)
                                            .frame(height: 50)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(10)
                CustomSecureField(placeholder: "profile_setting_view_placeholder_password".localized,
                                  text: $viewModel.password,
                                  isSecured: showPassword)
                    .overlay(toggleButton, alignment: .trailing)
                
                Toggle("profile_setting_view_biometric".localized,
                       isOn: $viewModel.isBiometricEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .foregroundColor(.white)
                
                let created = "profile_setting_view_created_date".localized
                Text(" \(created): \(Date.formatDate(from: viewModel.user?.created ?? ""))")
                    .foregroundColor(.white)
                
                let platform = "profile_setting_view_platform".localized
                Text(" \(platform): \(viewModel.user?.platform ?? "")")
                    .foregroundColor(.white)

                let updated = "profile_setting_view_updated_date".localized
                Text(" \(updated): \(Date.formatDate(from: viewModel.user?.updated ?? ""))")
                    .foregroundColor(.white)
                
                HStack {
                    Button {
                        showingImagePicker = true
                    } label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("profile_setting_view_select_image".localized)
                                .font(.system(size: 14))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue40)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        viewModel.updateUserProfile()
                        if let inputImage = inputImage {
                            viewModel.selectedImage = inputImage
                            viewModel.uploadSelectedImage()
                        }
                        showAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                            Text("profile_setting_view_save_changes".localized)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue40)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())

                }
            }
            .padding()
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(selectedImage: self.$inputImage, sourceType: .photoLibrary)
        }
        .alert(isPresented: $showAlert) { 
            Alert(title: Text("profile_setting_view_alert_saved".localized),
                  message: Text("profile_setting_view_alert_saved_message".localized),
                  dismissButton: .default(Text("OK")))
                }
    }

    private var toggleButton: some View {
        Button {
            self.showPassword.toggle()
        } label: {
            Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                .foregroundColor(.white)
        }
        .padding(.trailing, 15)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        viewModel.selectedImage = inputImage
    }
}

#Preview {
    ProfileSettingView(
        viewModel: ProfileSettingViewModel(
            dataManager: ProfileDataManager(
                apiClient: ApiClientSettingManager())))
}
