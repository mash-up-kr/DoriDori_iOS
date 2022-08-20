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
    var questionID: QuestionID?
    var content: String?
    var representativeAddress: String?
    var anonymous: Bool?
    var fromUser: QuestionUserModel?
    var toUser: QuestionUserModel?
    var answer: AnswerModel?
    var createdAt: Int { get }
}

struct AnswerModel: Codable {
    var answerID: AnswerID?
    var content: String?
    var representativeAddress: String?
    var user: QuestionUserModel?
    var likeCount: Int?
    var userLiked: Bool?
    var createdAt: Int { get }
}


struct QuestionUserModel: Codable {
    var userID: UserID?
    var nickname: String?
    var profileDescription: String?
    var tags: [String]?
    var profileImageURL: String?
    var level: Int?
}