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

    private init() {}

    ///загрузить аватар в хранилище
    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {

        let ref = Storage.storage().reference().child("avatars").child(currentUserId)

        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }

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


    ///достать аватар по URL
    func download(avatarURL: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: avatarURL)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            let image = UIImage(data: data)
            completion(.success(image ?? UIImage(systemName: "person.and.background.dotted")!))
        }
    }
    
}
