//
//  CreateAccountSwiftUIView.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 8/3/24.
//

import SwiftUI

struct CreateAccountSwiftUIView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: CreateAccountSwiftUIViewModel
    @State private var showAlert = false
    @State private var agreedToTerms = false
    
    var dismiss: (() -> Void)?
    var navigateBackToLogin: (() -> Void)?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                    .frame(height: 24)
                
                ZStack {
                    Image("iconVassQuick")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 120)
                        .presentationCornerRadius(8.0)
                        .padding(.top, 16)
                }
                
                // Espace between Picture and Register
                Text("create_account_registration".localized)
                    .font(.title)
                    .bold()
                    .padding(.top, 32)
                    .foregroundStyle(Color.white)
                
                // Espace between Register and Nick
                ZStack(alignment: .topLeading) {
                    TextField("create_account_nick".localized,
                            text: $viewModel.nick)
                        .padding(.leading, 36)
                        .padding(.trailing, 36)
                        .textFieldStyle(.roundedBorder)
                        .presentationCornerRadius(8.0)
                        .padding(.top, 24)
                        .disableAutocorrection(true)
                        .textContentType(.oneTimeCode)
                }
                
                // Espace between Nick and Login
                TextField("create_account_login".localized,
                        text: $viewModel.login)
                    .padding(.leading, 36)
                    .padding(.trailing, 36)
                    .textFieldStyle(.roundedBorder)
                    .presentationCornerRadius(8.0)
                    .padding(.top, 24)
                    .disableAutocorrection(true)
                    .textContentType(.oneTimeCode)
                
                // Espace between Login and Password
                SecureInputView("create_account_password".localized,
                        text: $viewModel.password)
                    .padding(.leading, 36)
                    .padding(.trailing, 36)
                    .textFieldStyle(.roundedBorder)
                    .presentationCornerRadius(8.0)
                    .padding(.top, 24)
                    .textContentType(.password)
                    .disableAutocorrection(true)
                
                SecureInputView("create_account_password_repeat".localized,
                        text: $viewModel.confirmPassword)
                    .padding(.leading, 36)
                    .padding(.trailing, 36)
                    .textFieldStyle(.roundedBorder)
                    .presentationCornerRadius(8.0)
                    .padding(.top, 24)
                    .textContentType(.password)
                    .disableAutocorrection(true)
                
                HStack {
                    Text("create_account_acept".localized)
                        .foregroundColor(.white)
                        .font(.footnote)
                        .lineLimit(1)
                    
                    NavigationLink(destination: WebView(url: "https://cloud.google.com/policy-intelligence/docs/iam-simulator-overview?hl=es-419")) {
                        Text("create_account_terms_and_conditions".localized)
                            .foregroundColor(Color.blue40)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $agreedToTerms)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(.trailing, 10)
                        .frame(width: 50, height: 30)
                }
                .padding(.leading, 36)
                .padding(.trailing, 36)
                .padding(.top, 24)
                
                Spacer()

                // SingUpButton
                Button {
                    viewModel.createAccount()
                    showAlert = true
                    self.navigateBackToLogin?()
                    
                } label: {
                    Text("create_account_sign_up_button".localized)
                        .frame(width: 358, height: 57)
                        .font(.title)
                    
                }
                .padding(.leading, 36)
                .padding(.trailing, 36)
                .buttonStyle(.borderedProminent)
                .scaleEffect(0.8)
                .disabled(!viewModel.isSignedButtonEnable || !agreedToTerms)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("create_account_alert".localized),
                        message: Text(viewModel.errorMessage ?? "create_account_error".localized))
                    }
                
                // Already Account
                HStack {
                    Text("create_account_already_text".localized)
                        .foregroundStyle(.white)
                    Button {
                        print("create_account_i_have_an_account_text".localized)
                        self.dismiss?()
                        self.navigateBackToLogin?()
                    } label: {
                        Text("create_account_login_back".localized)
                            .foregroundColor(Color.blue40)

                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color.black)
            .navigationBarTitle("")
            
            .navigationBarHidden(true)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("create_account_alert_acount_created".localized),
                      message: Text("create_account_alert_contratulations_text".localized))
            }
        }
    }
}

#Preview {
    CreateAccountSwiftUIView(viewModel: CreateAccountSwiftUIViewModel(
        dataManager: CreateAccountSwiftUIDataManager(
            apiClient: ApiClientRegisterManager())))
}
