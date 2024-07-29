//
//  TweetComposeViewViewModel.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 29.07.24.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewViewModel: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isValidToTweet: Bool = false
    @Published var tweetContent: String = ""
    @Published var error: String?
    @Published var shouldDismissComposer: Bool = false
    
    private var user: TwitterUser?
    
    func getUser() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
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
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func dispatchTweet() {
        guard let user = user else {return}
        let tweet = Tweet(author: user, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collecionTweets(dispatch: tweet)
            .sink { [weak self] completion in
                if case .failure(let error)  = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissComposer = state
            }
            .store(in: &subscriptions)

        
    }
    
    
}
