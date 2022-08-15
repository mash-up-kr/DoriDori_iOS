//
//  UserModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/15.
//

import Foundation

struct UserModel: Codable {
    var userID: UserID?
    var nickname: String?
    var tags: [String]?
    var profileImageURL: String?
    var level: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageURL = "profileImageUrl"
        case nickname, tags, level
    }
}
