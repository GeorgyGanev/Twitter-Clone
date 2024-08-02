//
//  ProfileViewViewModel.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 28.07.24.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(user: TwitterUser) {
        self.user = user
    }
    

    func getFormattedDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
    
    func fetchUserTweets() {

        DatabaseManager.shared.collectionTweets(retrieveTweetsFor: user.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] tweets in
                self?.tweets = tweets
            }
            .store(in: &subscriptions)

    }
    
}
