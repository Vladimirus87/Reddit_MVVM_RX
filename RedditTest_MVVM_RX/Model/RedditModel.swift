//
//  RedditModel.swift
//  RedditTest_MVVM_RX
//
//  Created by Vladimirus on 05.02.2021.
//

import Foundation

// MARK: - RedditModel
struct RedditModel: Codable {
    let data: RedditModelData
}

// MARK: - RedditModelData
struct RedditModelData: Codable {
    let children: [Child]
}

// MARK: - Child
struct Child: Codable {
    let data: ChildData
}

// MARK: - ChildData
struct ChildData: Codable {
    let name: String
    let title: String
    let author: String
    let dateCreated: Double
    let thumbnailUrl: String?
    let imageUrl: String?
    let numberOfComments: Int
    
    
    enum CodingKeys: String, CodingKey {
        case name, title, author
        case dateCreated = "created"
        case thumbnailUrl = "thumbnail"
        case imageUrl = "url"
        case numberOfComments = "num_comments"
    }
}
