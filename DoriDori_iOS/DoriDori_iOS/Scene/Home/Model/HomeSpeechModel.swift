//
//  HomeSpeechModel.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/16.
//

import Foundation

struct HomeSpeechs<HomeSpeech: Codable>: Codable {
    let speech: [HomeSpeech]
    let hasNext: Bool
}

struct HomeSpeech: Codable {
    let id: String
    let user: UserInfo
    let content: String
    let likeCount, commentCount: Int
    let userLiked: Bool
    let longitude, latitude: Double
    let representativeAddress: String
    let anonymous: Bool
    let createdAt, updatedAt: String
}

struct UserInfo: Codable {
    let id: String
    let tags: [String]
    let nickname: String
    let profileImageURL: String
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case id, tags, nickname
        case profileImageURL = "profileImageUrl"
        case level
    }
}
