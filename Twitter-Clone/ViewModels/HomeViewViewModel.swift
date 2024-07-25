//
//  HomeViewViewModel.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 24.07.24.
//

import Foundation
import FirebaseAuth
import Combine

final class HomeViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retrieveUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)

    }
    
}
