//
//  UserInfoModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import Foundation

typealias UserID = String

struct UserInfoModel: Codable {
    var userID: UserID?
    var nickname: String?
    var profileDescription: String?
    var tags: [String]?
    var profileImageURL: String?
    var level: Int?
    var representativeWard: String?
    
    enum CodingKeys: String, CodingKey {
        case nickname, profileDescription, tags, level
        case userID = "userId"
        case profileImageURL = "profileImageUrl"
    }
}

