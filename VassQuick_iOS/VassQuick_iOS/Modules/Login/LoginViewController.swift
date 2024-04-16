//
//  LoginViewController.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 7/3/24.
//

import Combine
import LocalAuthentication
import SwiftUI
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: LoginViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var isChecked: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var btRegister: UIButton!
    @IBOutlet weak var lbErrorPassword: UILabel!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lbErrorLogin: UILabel!
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbRememberUserLabel: UILabel!
    @IBOutlet weak var swRememberUserSwitch: UISwitch!
    @IBOutlet weak var btBiometricAuth: UIButton!
    @IBOutlet weak var lbNotAnAccount: UILabel!
    @IBOutlet weak var vwLoadingView: UIView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideErrorMessage()
        setupDesign()
        setupBindings()
        configureTextFieldDelegate()
        btBiometricAuth.isEnabled = false
        viewModel.updateBiometricAuthButtonState()
        adjustForRememberUserSwitchState()
        checkRememberUserStatus()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
    
    private func checkRememberUserStatus() {
        if !viewModel.getRememberUser() {
            KeyChainManager.shared.deleteToken()
        } else {
            _ = swRememberUserSwitch.isOn
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.hidesBackButton = true 
    }
    
    // MARK: - Private
    private func adjustForRememberUserSwitchState() {
        let isRememberUserEnabled = viewModel.getRememberUser()
        swRememberUserSwitch.isOn = isRememberUserEnabled
        
        if isRememberUserEnabled {
            tfLogin.text = viewModel.getUsername()
        } else {
            tfLogin.text = ""
            tfPassword.text = ""
        }
    }

    // MARK: - Setup
    func set(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    private func hideErrorMessage() {
        lbErrorLogin.isHidden = true
        lbErrorPassword.isHidden = true
    }
    
    private func setupBindings() {
        lbErrorLogin.isHidden = true
        lbErrorPassword.isHidden = true
        btLogin.isEnabled = false
        
        let loginPublisher = tfLogin.publisher(for: \.text).map { text in
            return !(text ?? "").isEmpty
        }
        let passwordPublisher = tfPassword.publisher(for: \.text).map { text in
            return !(text ?? "").isEmpty
        }

        Publishers.CombineLatest(loginPublisher, passwordPublisher)
            .map { loginNotEmpty, passwordNotEmpty in
                return loginNotEmpty && passwordNotEmpty
            }
            .assign(to: \.isEnabled, on: btLogin)
            .store(in: &cancellables)

        viewModel.$loginError
            .receive(on: DispatchQueue.main)
            .map { $0 == nil }
            .assign(to: \.isHidden, on: lbErrorLogin)
            .store(in: &cancellables)

        viewModel.$passwordError
            .receive(on: DispatchQueue.main)
            .map { $0 == nil }
            .assign(to: \.isHidden, on: lbErrorPassword)
            .store(in: &cancellables)
        
        viewModel.$isBiometricAuthButtonEnabled
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] isEnabled in
                        self?.btBiometricAuth.isEnabled = isEnabled
                    }
                    .store(in: &cancellables)
    }

    private func setupDesign() {
        view.backgroundColor = .black
        imgIcon.image = UIImage(named: "iconVassQuick")
        lbTitle.textColor = .white
        lbTitle.text = "login_view_controller_nickname".localized
        lbTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        configureTextField(tfLogin, placeholder: "login_view_controller_placeholder_login".localized, 
                           height: 50)
        configureTextField(tfPassword, placeholder: "login_view_controller_placeholder_password".localized,
                           height: 50)
        
        lbErrorLogin.isHidden = true
        lbErrorPassword.isHidden = true
        lbErrorLogin.text = "login_view_controller_error_login".localized
        lbErrorPassword.text = "login_view_controller_error_password".localized

        lbErrorLogin.textColor = .red
        lbErrorPassword.textColor = .red
        
        btLogin.setTitle("login_view_controller_login_button".localized, for: .normal)
        btLogin.setTitleColor(.white, for: .normal)
        btLogin.layer.cornerRadius = 11

        btRegister.setTitle("login_view_controller_register_button".localized, for: .normal)
        btRegister.setTitleColor(.blue40, for: .normal)
        
        btBiometricAuth.setTitleColor(.blue40, for: .normal)
        
        let loginPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tfLogin.frame.height))
        tfLogin.leftView = loginPaddingView
        tfLogin.leftViewMode = .always
        tfLogin.rightView = loginPaddingView
        tfLogin.rightViewMode = .always

        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tfPassword.frame.height))
        tfPassword.leftView = passwordPaddingView
        tfPassword.leftViewMode = .always
        tfPassword.rightView = passwordPaddingView
        tfPassword.rightViewMode = .always
        
        swRememberUserSwitch.isOn = viewModel.getRememberUser()
        if swRememberUserSwitch.isOn {
            tfLogin.text = viewModel.getUsername()
        }
        
        lbNotAnAccount.text = "login_view_controller_not_an_account".localized
        lbRememberUserLabel.text = "login_view_controller_remember_user".localized
        
        viewModel.removeUserId()
    }

    private func configureTextField(_ textField: UITextField, placeholder: String, height: CGFloat) {
         textField.borderStyle = .none
         textField.textColor = .white
         textField.attributedPlaceholder = NSAttributedString(
             string: placeholder,
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
         )
         textField.backgroundColor = .clear
         textField.layer.borderColor = UIColor.white.cgColor
         textField.layer.borderWidth = 2.0
         textField.layer.cornerRadius = 11.0

         textField.translatesAutoresizingMaskIntoConstraints = false

         NSLayoutConstraint.activate([
             textField.heightAnchor.constraint(equalToConstant: height)
         ])
     }
    
    private func configureTextFieldDelegate() {
        tfLogin.delegate = self
        tfPassword.delegate = self
        btLogin.isEnabled = false
    }

    // MARK: - Actions
    @IBAction func tappedSwitchUserRemember(_ sender: UISwitch) {
        viewModel.setRememberUser(sender.isOn)
        if sender.isOn {
            viewModel.saveUsername(tfLogin.text)
        } else {
            viewModel.removeUsername()
            tfLogin.text = ""
            tfPassword.text = ""
        }
        viewModel.updateBiometricAuthButtonState()
    }
    
    private func configureBiometricButton() {
        btBiometricAuth.isEnabled = viewModel.shouldEnableBiometricButton()
    }
    
    @IBAction func tappedRegister(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(true, animated: false)

        let createAccountSwiftUIController = UIHostingController(rootView: CreateAccountSwiftUIView(
            viewModel: CreateAccountSwiftUIViewModel(
                dataManager: CreateAccountSwiftUIDataManager(
                    apiClient: ApiClientRegisterManager())),
            dismiss: {
                self.dismiss(animated: true, completion: nil)
            },
            navigateBackToLogin: {
                self.navigationController?.popViewController(animated: true)
            }))
        
        navigationController?.pushViewController(createAccountSwiftUIController, animated: true)
    }
    
    @IBAction func tappedLogin(_ sender: UIButton) {
        lbErrorLogin.isHidden = true
        lbErrorPassword.isHidden = true
        vwLoadingView.isHidden = false

        guard let login = tfLogin.text, !login.isEmpty,
              let password = tfPassword.text, !password.isEmpty else {
            lbErrorLogin.isHidden = !(tfLogin.text?.isEmpty ?? true)
            lbErrorPassword.isHidden = tfPassword.text?.isEmpty ?? true

            return
        }

        viewModel.loginUser(login: login, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.lbErrorLogin.isHidden = true
                    self?.lbErrorPassword.isHidden = false
                    self?.vwLoadingView.isHidden = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] loginResponse in
                if self?.swRememberUserSwitch.isOn == true {
                    KeyChainManager.shared.save(token: loginResponse.token)
                    self?.viewModel.setRememberUser(true)
                } else {
                    self?.viewModel.setRememberUser(false)
                }
                self?.navigateToContactList()
            })
            .store(in: &cancellables)        
    }
    
    func activateBiometri() {
        if viewModel.checkExistToken() {
            btBiometricAuth.isEnabled = true
        } else {
            btBiometricAuth.isEnabled = false
        }
            
    }
    
    @IBAction func tappedBiometricAuth(_ sender: UIButton) {
        let biometricAuth = BiometricAuthentication()
            
            if biometricAuth.isAvailable {
                biometricAuth.authenticationWithBiometric(
                    reason: "login_view_controller_authentification_biometric".localized) { [weak self] in
                    self?.viewModel.getBiometriAuth { loginResponse in
                        DispatchQueue.main.async {
                            KeyChainManager.shared.save(token: loginResponse.token)
                            self?.navigateToContactList()
                        }
                    }
                } onFailure: { error in
                    DispatchQueue.main.async {
                        self.showBiometricErrorAlert(error: error)
                    }
                }
            } else {
                showBiometricNotAvailableAlert()
            }
        }
    
    private func showBiometricNotAvailableAlert() {
        let alert = UIAlertController(title: "login_view_controller_biometric_alert".localized,
                                      message: "login_view_controller_biometric_alert_message".localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    private func showBiometricErrorAlert(error: LAError) {
        let message: String

        switch error.code {
        case .authenticationFailed:
            message = "login_view_controller_authentification_failed".localized
        case .userCancel, .systemCancel:
            message = "login_view_controller_authentification_cancel".localized
        case .touchIDLockout:
            message = "login_view_controller_authentification_touchID_cancel".localized
        case .touchIDNotAvailable:
            message = "login_view_controller_authentification_touchID_not_available".localized
        case .userFallback:
            message = "login_view_controller_authentification_code".localized
        default:
            message = "login_view_controller_authentification_error".localized
        }

        DispatchQueue.main.async {
            let alert = UIAlertController(title: "login_view_controller_authentification_alert_error".localized, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    private func navigateToContactList() {
        let contactListWireframe = ChatListWireframe()
        contactListWireframe.push(navigation: self.navigationController)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let loginNotEmpty = !(tfLogin.text ?? "").isEmpty
        let passwordNotEmpty = !(tfPassword.text ?? "").isEmpty
        
        btLogin.isEnabled = loginNotEmpty && passwordNotEmpty
    }
}
