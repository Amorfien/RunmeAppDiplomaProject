//
//  AuthManager.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import FirebaseAuth
import Foundation

final class AuthManager {

    static let shared = AuthManager()

    private let auth = Auth.auth()

    var currentUser: User? {
        return auth.currentUser
    }

    private var verificationID: String?

    private init() {}


    func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {

        Auth.auth().settings?.isAppVerificationDisabledForTesting = true ///тестовый режим, отключение капчи, только забитые юзеры

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID, error == nil else {
                completion(false)
                return
            }
            self?.verificationID = verificationID
            completion(true)
        }
    }

    func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {

        guard let verificationID else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }

    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Auth SinOut Error?")
        }
    }


}
