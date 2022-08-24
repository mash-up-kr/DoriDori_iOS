//
//  QuestionModel.swift
//  DoriDori_iOS
//
//  Created by GardenLee on 2022/08/20.
//

import Foundation

typealias QuestionID = String
typealias AnswerID = String

struct QuestionModel: Codable {
    var id: QuestionID?
    var content: String?
    var representativeAddress: String?
    var anonymous: Bool?
    var fromUser: QuestionUserModel?
    var toUser: QuestionUserModel?
    var answer: AnswerModel?
    var createdAt: String?
}

struct AnswerModel: Codable {
    var id: AnswerID?
    var content: String?
    var representativeAddress: String?
    var user: QuestionUserModel?
    var likeCount: Int?
    var userLiked: Bool?
    var createdAt: String?
}


struct QuestionUserModel: Codable {
    var id: UserID?
    var nickname: String?
    var profileDescription: String?
    var tags: [String]?
    var profileImageURL: String?
    var level: Int?
}
