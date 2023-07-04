//
//  FirebaseStorageService.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 25.06.2023.
//

import UIKit
import FirebaseStorage

final class FirebaseStorageService {

    static let shared = FirebaseStorageService()
//    let megaByte = Int64(1 * 1024 * 1024)

    private init() {}

    ///загрузить аватар в хранилище
    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {

        let ref = Storage.storage().reference().child("avatars").child(currentUserId)

        guard let imageData = photo.jpegData(compressionQuality: 0.3) else { return }

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        ref.putData(imageData, metadata: metaData) { metaData, metaDataError in
            guard metaData != nil else {
                completion(.failure(metaDataError!))
                return
            }
            ref.downloadURL { url, urlError in
                guard let url, urlError == nil else {
                    completion(.failure(urlError!))
                    return
                }
                completion(.success(url))
            }

        }
    }

    ///достать аватар по ID
    func downloadById(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let ref = Storage.storage().reference().child("avatars").child(id)
        let megaByte = Int64(3 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
//            let image = UIImage(data: data)
            completion(.success(data))
        }
    }


    ///достать все аватары
    func downloadAllAvatars(completion: @escaping (Result<[String: Data], Error>) -> Void) {

        var imgArray: [String: Data] = [:]

        let ref = Storage.storage().reference().child("avatars")
        ref.listAll { result in
            switch result {
            case .success(let storageList):

                let megaByte = Int64(3 * 1024 * 1024)

                for item in storageList.items {
                    print(item.name)
                    item.getData(maxSize: megaByte) { dataRes in
                        switch dataRes {
                        case .success(let data):
                            imgArray[item.name] = data
                            if imgArray.count == storageList.items.count {
                                completion(.success(imgArray))
                            }
                        case .failure(let dataError):
                            completion(.failure(dataError))
                        }
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }


    }
    
}
