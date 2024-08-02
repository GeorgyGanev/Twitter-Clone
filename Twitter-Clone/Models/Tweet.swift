//
//  Tweet.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 29.07.24.
//

import Foundation

struct Tweet: Identifiable, Codable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorId: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    var isReply: Bool
    let parentReference: String?
}
