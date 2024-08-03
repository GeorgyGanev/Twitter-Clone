//
//  DatabaseManager.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 24.07.24.
//

import Foundation
import Firebase
import FirebaseFirestoreCombineSwift
import Combine
import FirebaseFirestoreSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    let tweetsPath: String = "tweets"
    let followingsPath: String = "followings"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error>{
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retrieve id: String) -> AnyPublisher<TwitterUser, Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap {
                try $0.data(as: TwitterUser.self)
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        db.collection(usersPath).document(id).updateData(updateFields)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(search query: String) -> AnyPublisher<[TwitterUser], Error> {
        db.collection(usersPath).whereField("username", isEqualTo: query)
            .getDocuments()
            .map(\.documents)
            .tryMap { snapshots in
                try snapshots.map {
                    try $0.data(as: TwitterUser.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func collecionTweets(dispatch tweet: Tweet) -> AnyPublisher<Bool, Error> {
        db.collection(tweetsPath).document(tweet.id).setData(from: tweet)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(retrieveTweetsFor userId: String) -> AnyPublisher<[Tweet], Error>  {
        db.collection(tweetsPath).whereField("authorId", isEqualTo: userId)
            .getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map {
                   try $0.data(as: Tweet.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func collectionsFollowings(follower: String, following: String) -> AnyPublisher<Bool, Error> {
        db.collection(followingsPath)
            .whereField("follower", isEqualTo: follower)
            .whereField("following", isEqualTo: following)
            .getDocuments()
            .map(\.count)
            .map {
                $0 != 0
            }
            .eraseToAnyPublisher()
    }
    
}
