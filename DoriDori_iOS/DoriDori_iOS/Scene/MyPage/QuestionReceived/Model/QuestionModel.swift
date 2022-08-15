//
//  QuestionModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/15.
//

import Foundation

struct QuestionModel: Codable {
    var id: String?
    var content: String?
    var location: String?
    var anonymous: Bool?
    var fromUser: UserModel?
    var toUser: UserModel?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, content, anonymous, fromUser, toUser, createdAt
        case location = "representativeAddress"
    }
}
