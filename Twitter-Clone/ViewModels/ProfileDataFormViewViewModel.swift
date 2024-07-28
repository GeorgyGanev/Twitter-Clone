//
//  ProfileDataFormViewViewModel.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 24.07.24.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseStorageCombineSwift
import Combine
import FirebaseAuth

final class ProfileDataFormViewViewModel: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String?
    @Published var isOnboardingFinished: Bool = false
    
    
    func validateUserProfileForm() {
        if let displayName = displayName,
           displayName.trimmingCharacters(in: .whitespaces).count > 2,
           let username = username,
           username.trimmingCharacters(in: .whitespaces).count > 2,
           let bio = bio,
           bio.trimmingCharacters(in: .whitespaces).count > 3,
           imageData != nil {
            isFormValid = true
            return
        } else {
            isFormValid = false
            return
        }
    }
    
    func uploadAvatar() {
        let randomId = UUID().uuidString
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
       
        StorageManager.shared.uploadProfilePhoto(with: randomId, imageData: imageData, metaData: metaData)
            .flatMap({ metaData in
                StorageManager.shared.getDownloadUrl(for: metaData.path)
                
            })
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    
                    self?.uploadUserData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] url in
                self?.avatarPath = url.absoluteString
            })
            .store(in: &subscriptions)

    }
    
    private func uploadUserData() {
        guard let displayName,
              let username,
              let bio,
              let avatarPath,
              let userId = Auth.auth().currentUser?.uid else {return}
        
        let updatedFields: [String: Any] = [
            "displayName": displayName,
            "username": username,
            "bio": bio,
            "avatarPath": avatarPath,
            "isUserOnboarded": true
        ]
        
        DatabaseManager.shared.collectionUsers(updateFields: updatedFields, for: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] onboardingState in
                self?.isOnboardingFinished = onboardingState
            }
            .store(in: &subscriptions)

    }
    
    
}
