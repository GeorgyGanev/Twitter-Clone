//
//  StorageManager.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 28.07.24.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FireStorageError: Error {
    case invalidImageId
}

class StorageManager {
    
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    func uploadProfilePhoto(with referenceId: String, imageData: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        
        return storage
            .reference()
            .child("images/\(referenceId).jpg")
            .putData(imageData, metadata: metaData)
            .eraseToAnyPublisher()
    }
    
    func getDownloadUrl(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else {
            return Fail(error: FireStorageError.invalidImageId)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .eraseToAnyPublisher()
    }
}

