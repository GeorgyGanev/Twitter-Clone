//
//  ProfileViewViewModel.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 28.07.24.
//

import Foundation
import Combine
import FirebaseAuth

enum ProfileFollowingState {
    case userIsFollowed
    case userIsNotFollowed
    case personal
}

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var currentFollowingState: ProfileFollowingState = .personal
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(user: TwitterUser) {
        self.user = user
        checkIfFollowed()
    }
    
    private func checkIfFollowed() {
        guard let personalUserId = Auth.auth().currentUser?.uid,
              personalUserId != user.id 
        else {
            currentFollowingState = .personal
            return
        }
        DatabaseManager.shared.collectionsFollowings(checkFollower: personalUserId, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isFollowed in
                self?.currentFollowingState = isFollowed ? .userIsFollowed : .userIsNotFollowed
            }
            .store(in: &subscriptions)

    }
    
    func follow() {
        guard let personalId = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.collectionFollowings(follower: personalId , willFollow: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isFollowed in
                self?.currentFollowingState = .userIsFollowed
            }
            .store(in: &subscriptions)

    }
    
    func unfollow() {
        guard let personalId = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.collectionFollowings(delete: personalId, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isFollowed in
                self?.currentFollowingState = .userIsNotFollowed
            }
            .store(in: &subscriptions)
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
