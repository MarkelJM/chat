//
//  BiometricAuthentication.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 20/3/24.
//

import Foundation
import LocalAuthentication

public struct BiometricAuthentication {

    let localAuthenticationContext: LAContext

    /// It could be TouchId, FaceId or none
    public var biometricType: LABiometryType {
        guard canEvaluatePolicy() else { return .none }

        return localAuthenticationContext.biometryType
    }

    /// Determinate if biometric authentication is available
    public var isAvailable: Bool {
        return biometricType != .none
    }

    // MARK: Lifecycle

    public init(context: LAContext = LAContext()) {
        
        self.localAuthenticationContext = context
        self.localAuthenticationContext.localizedFallbackTitle = "Por favor, utiliza tu código de desbloqueo"
    }

    /// Request biometric Authentication ( TouchID or FaceID )
    /// - Parameters:
    ///   - reason: Set permission Text for Touch ID
    ///   - onSuccess: Biometric authentication has been succesful
    ///   - onFailure: Returns a LAError:
    /**
       - case LAError.AppCancel
       - case LAError.AuthenticationFailed
       - case LAError.InvalidContext
       - case LAError.PasscodeNotSet
       - case LAError.SystemCancel
       - case LAError.TouchIDLockout
       - case LAError.TouchIDNotAvailable
       - case LAError.UserCancel
       - case LAError.UserFallback
     */
    ///
    public func authenticationWithBiometric(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics, reason: String = "Autenticación requerida para continuar", onSuccess: @escaping () -> Void, onFailure: @escaping (LAError) -> Void) {

        localAuthenticationContext.evaluatePolicy(policy, localizedReason: reason) { success, error in
            if success {
                onSuccess()
            } else {
                if let error = error as? LAError {
                    onFailure(error)
                }
            }
        }
    }

    // MARK: Private methods

    /// Determinate if device has touchId or FaceID
    /// - Returns: Boolean
    private func canEvaluatePolicy() -> Bool {
        return localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
