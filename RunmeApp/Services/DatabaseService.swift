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
    private var postsRef: CollectionReference {
        return db.collection("posts")
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

    ///обновить юзера в базе
    func updateUser(user: Runner, completion: @escaping (Result<Runner, Error>) -> Void) {
        usersRef.document(user.id).setData(user.representation, merge: true) { error in
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
            let postsId = data["postsId"] as? [String]

            let runner = Runner(id: id, phoneNumber: phoneNumber, nickname: nickname, name: name, surname: surname, statusText: statusText, isMale: isMale ?? true, email: email, telegram: telegram, birthday: birthday, birthdayShow: birthdayShow ?? true, isAdmin: isAdmin ?? false, personalBests: personalBests ?? [0, 0, 0, 0], achievements: achievements ?? [], postsId: postsId ?? [])

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
                    if id == "_adminadmin" {
                        updBests = [100_001, 100_001, 100_001, 100_001]
                    }

                    let bests = RunnersBests(id: id, nickname: nickname, isMale: isMale, personalBests: updBests)
                    runnersBests.append(bests)

                    if runnersBests.count == snapshot?.count {
                        completion(.success(runnersBests))
                    }
                }
            }
        }

    }

//MARK: - POSTS

    ///записать пост в базу
    func savePost(post: RunnerPost, completion: @escaping (Result<String, Error>) -> Void) {
        postsRef.document(post.postId).setData(post.representation) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(post.postId))
            }
        }
    }

    ///достать все посты
    func getAllPosts (completion: @escaping (Result<[RunnerPost], Error>) -> Void) {
        var posts: [RunnerPost] = []
        postsRef.getDocuments { snapshot, error in
            if let error {
                completion(.failure(error))
            } else if (snapshot?.isEmpty)! {
                completion(.success([]))
            } else {
                for document in (snapshot?.documents)! {
                    let postId = document.data()["postId"] as? String ?? "???"
                    let userId = document.data()["userId"] as? String ?? "???"
                    let userNickname = document.data()["userNickname"] as? String ?? "???"
                    let date = document.data()["date"] as? String ?? "??.??.????"
                    let text = document.data()["text"] as? String ?? ""
                    let distance = document.data()["distance"] as? Double ?? 1
                    let time = document.data()["time"] as? Double ?? 0
                    let likes = document.data()["likes"] as? [String] ?? []

                    let post = RunnerPost(postId: postId, userId: userId, userNickname: userNickname, date: date, text: text, distance: distance, time: time, likes: likes)
                    posts.append(post)
                }
                completion(.success(posts))
            }
        }
    }

    ///обновить пост  в базе (изменить список лайкнувших)
    func updatePost(post: RunnerPost, completion: @escaping (Result<RunnerPost, Error>) -> Void) {
        postsRef.document(post.postId).setData(post.representation, merge: true) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(post))
            }
        }
    }

    ///достать один пост из базы по ID (чтобы получить пост непосредственно перед изменениями)
    func fetchPost(postIdd: String, completion: @escaping (Result<RunnerPost, Error>) -> Void) {

        postsRef.document(postIdd).getDocument { docSnapshot, error in
            guard error == nil else { completion(.failure(error!)); return }
            guard let docSnapshot else { return }
            guard let data = docSnapshot.data() else { return }

            let postId = data["postId"] as? String ?? "???"
            let userId = data["userId"] as? String ?? "???"
            let userNickname = data["userNickname"] as? String ?? "???"
            let date = data["date"] as? String ?? "??.??.????"
            let text = data["text"] as? String ?? ""
            let distance = data["distance"] as? Double ?? 0
            let time = data["time"] as? Double ?? 0
            let likes = data["likes"] as? [String] ?? []

            let post = RunnerPost(postId: postId, userId: userId, userNickname: userNickname, date: date, text: text, distance: distance, time: time, likes: likes)
            completion(.success(post))
        }
    }

    ///удалить пост
    func deletePost(postIdd: String, completion: @escaping (Bool) -> Void) {
        postsRef.document(postIdd).delete { error in
            if let error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

}
