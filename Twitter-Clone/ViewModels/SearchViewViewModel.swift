//
//  SearchViewViewModel.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 2.08.24.
//

import Foundation
import Combine

final class SearchViewViewModel {
    
    var subscriptions = Set<AnyCancellable>()
    
    func search(with query: String, completion: @escaping([TwitterUser]) -> Void) {
        DatabaseManager.shared.collectionUsers(search: query).sink { completion in
            if case .failure(let error) = completion {
                print(error.localizedDescription)
            }
        } receiveValue: { users in
            completion(users)
        }
        .store(in: &subscriptions)

    }
}
