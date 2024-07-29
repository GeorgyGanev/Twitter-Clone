//
//  Tweet.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 29.07.24.
//

import Foundation

struct Tweet: Identifiable, Encodable {
    let id = UUID().uuidString
    let author: TwitterUser
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    var isReply: Bool
    let parentReference: String?
}
