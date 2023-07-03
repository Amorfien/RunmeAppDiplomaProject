//
//  DatabaseService.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation
import FirebaseFirestore

final class DatabaseService {

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

            guard error == nil else { completion(.failure(error!)); return }
            guard let docSnapshot else { return }
            guard let data = docSnapshot.data() else { return }

            guard let id = data["id"] as? String else { return }
            guard let phoneNumber = data["phoneNumber"] as? String else { return }
            guard let nickname = data["nickname"] as? String else { return }

            let name = data["name"] as? String
            let surname = data["surname"] as? String
            let statusText = data["statusText"] as? String
            let isMale = data["isMale"] as? Bool
            let email = data["email"] as? String
            let telegram = data["telegram"] as? String
            let birthday = data["birthday"] as? String
            let birthdayShow = data["birthdayShow"] as? Bool
            let isAdmin = data["isAdmin"] as? Bool
            let personalBests = data["personalBests"] as? [Int]
            let achievements = data["achievements"] as? [String]
            let posts = data["posts"] as? [String]
            // дописать
            let runner = Runner(id: id, phoneNumber: phoneNumber, nickname: nickname, name: name, surname: surname, statusText: statusText, isMale: isMale ?? true, email: email, telegram: telegram, birthday: birthday, birthdayShow: birthdayShow ?? true, isAdmin: isAdmin ?? false, personalBests: personalBests ?? [0, 0, 0, 0], achievements: achievements ?? [], posts: posts ?? [])

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

    }


    ///достать всех юзеров
    func getAllUsers (completion: @escaping (Result<[RunnersBests], Error>) -> Void) {

        var runnersBests: [RunnersBests] = []
//        usersRef.whereField("personalBests", isGreaterThan: [0, 0, 0, 0]).getDocuments
        usersRef.getDocuments { snapshot, error in
            if let error {
                completion(.failure(error))
            } else if (snapshot?.isEmpty)! {
                completion(.success([]))
            } else {
                for document in (snapshot?.documents)! {
                    guard let id = document.data()["id"] as? String else { print("0001"); return }
                    let personalBests = document.data()["personalBests"] as? [Int]
                    let nickname = document.data()["nickname"] as? String ?? "???"
                    let isMale = document.data()["isMale"] as? Bool ?? true

                    var updBests: [Int] = personalBests ?? [0, 0, 0, 0]
                    for (i, item) in updBests.enumerated() {
                        if item == 0 {
                            updBests[i] = 100_000
                        }
                    }

                    let bests = RunnersBests(id: id, nickname: nickname, isMale: isMale, personalBests: updBests)
                    runnersBests.append(bests)

                    if runnersBests.count == snapshot?.count {//storageList.items.count {
                        completion(.success(runnersBests))
                    }
                }
            }
        }



    }



}


//enum DatabaseServiceError: String, Error {
//
//    case emptySnapshot
//
//    var localizedDescription: String {
//        return self.rawValue
//    }
//
//}
