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


    func startAuth(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {

        Auth.auth().settings?.isAppVerificationDisabledForTesting = false ///true - тестовый режим, отключение капчи, только забитые юзеры

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let verificationID, error == nil {
//                return
            self?.verificationID = verificationID
                completion(.success(true))
            } else if let error {
                completion(.failure(error))
            } else {
                completion(.success(false))
            }
        }
    }

    func verifyCode(smsCode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let verificationID else {
            completion(.success(false))
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )
        auth.signIn(with: credential) { result, error in
            if result != nil, error == nil {
                completion(.success(true))
            } else if let error {
                completion(.failure(error))
            } else {
                completion(.success(false))
            }
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
