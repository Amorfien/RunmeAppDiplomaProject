//
//  DatabaseService.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation
import FirebaseFirestore

class DatabaseService {

    static let shared = DatabaseService()

    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }

    private init() {}

    ///записать юзера в базу
    func setUser(user: Runner, completion: @escaping (Result<Runner, Error>) -> Void) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }

    ///прочитать юзера из базы
    func getUser(userId: String, completion: @escaping (Result<Runner, Error>) -> Void) {
        usersRef.document(userId).getDocument { docSnapshot, error in

            guard let docSnapshot else { return }
            guard let data = docSnapshot.data() else { return }

            guard let id = data["id"] as? String else { return }
            guard let phoneNumber = data["phoneNumber"] as? String else { return }

            let name = data["name"] as? String
            //
            //
            // дописать
            let runner = Runner(id: id, phoneNumber: phoneNumber, name: name, surname: nil, birthday: nil)

            completion(.success(runner))
        }
    }

    ///проверка нового юзера на наличие в базе
    func searchUserInDb(userId: String, completion: @escaping (Bool) -> Void) {

        usersRef.whereField("id", isEqualTo: userId).getDocuments { snapshot, error in
            if let error {
                print(error.localizedDescription)
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["id"] != nil {
                        completion(true)
                    }
                }
            }
        }


//        if AuthManager.shared.currentUser?.uid == "VH77VEBCMFNrokiTteI167yxU1B2" {
//            completion(true)
//        } else {
//            completion(false)
//        }
    }

}
