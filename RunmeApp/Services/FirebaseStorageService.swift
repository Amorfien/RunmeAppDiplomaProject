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


    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {

        let ref = Storage.storage().reference().child("avatars").child(currentUserId)

        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        ref.putData(imageData, metadata: metaData) { metaData, metaDataError in
            guard let metaData else {
                completion(.failure(metaDataError!))
                return
            }
            ref.downloadURL { url, urlError in
                guard let url else {
                    completion(.failure(urlError!))
                    return
                }
                completion(.success(url))
            }

        }
    }
    
}
