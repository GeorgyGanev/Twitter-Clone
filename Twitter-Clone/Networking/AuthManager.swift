//
//  AuthManager.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 21.07.24.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

class AuthManager {
    
    static let shared = AuthManager()
    
    func createUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func loginUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
}
