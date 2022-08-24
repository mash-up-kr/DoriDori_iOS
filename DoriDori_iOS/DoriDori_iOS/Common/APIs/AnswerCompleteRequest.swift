//
//  UserInfoRequest.swift
//  DoriDori_iOS
//
//  Created by GardenLee on 2022/08/20.
//

import Foundation

// 본인
struct MyAnswerCompleteRequest: Requestable {
    private let size: Int
    private let lastQuestionID: QuestionID?
    var path: String { "/api/v1/user/answered-questions" }
    var parameters: Parameter? {
        if let lastQuestionID = self.lastQuestionID {
            return [
                "lastId": lastQuestionID,
                "size": self.size
            ]
        } else {
            return [
                "size": self.size
            ]
        }
    }
    init(lastQuestionID: QuestionID?, size: Int) {
        self.lastQuestionID = lastQuestionID
        self.size = size
    }
}

// 다른사람
struct AnswerCompleteRequest: Requestable {
    private let userID: UserID
    private let lastQuestionID: QuestionID?
    private let size: Int
    
    var path: String { "/api/v1/questions/answered" }
    var parameters: Parameter? {
        if let lastQuestionID = lastQuestionID {
            return [
                "userId": self.userID,
                "lastId": lastQuestionID,
                "size": self.size
            ]
        } else {
            return [
                "userId": self.userID,
                "size": self.size
            ]
        }
    }
    init(userID: UserID, lastQuestionID: QuestionID?, size: Int) {
        self.userID = userID
        self.lastQuestionID = lastQuestionID
        self.size = size
    }
}
