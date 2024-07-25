//
//  ProfileDataFormViewViewModel.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 24.07.24.
//

import Foundation

final class ProfileDataFormViewViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
}
