//
//  Local.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 25.06.2023.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {

    private let context: LAContext = LAContext()
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    var sensorType = ""

    init() {
        context.localizedCancelTitle = "Войти по логину и паролю"
        if context.canEvaluatePolicy(policy, error: nil) {
            self.sensorType = context.biometryType == .faceID ? "faceid" : "touchid"
        }
    }

    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {

        let canEvaluate = context.canEvaluatePolicy(policy, error: nil)

        if canEvaluate {

            context.evaluatePolicy(policy, localizedReason: "Тут что-то для TouchID") { success, error in
                if success {
                    authorizationFinished(true)
                } else { return }
            }
        } else { authorizationFinished(false) }

    }

}
