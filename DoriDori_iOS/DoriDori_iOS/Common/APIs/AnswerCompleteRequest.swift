//
//  UserInfoRequest.swift
//  DoriDori_iOS
//
//  Created by GardenLee on 2022/08/20.
//

import Foundation

// 본인
struct MyAnswerCompleteRequest: Requestable {
    var path: String { "/api/v1/user/answered-questions?lastId=\(self.lastQuestionID)&size=\(self.size)" }
    var parameters: Parameter? { nil }
    init(lastQuestionID: QuestionID?, size: Int) {
        self.lastQuestionID = lastQuestionID
        self.size = size
    }
}

// 다른사람
struct AnswerCompleteRequest: Requestable {
    var path: String { "/api/v1/questions/answered?userId=\(self.userID)&lastId=\(self.lastQuestionID)&size=\(self.size)" }
    var parameters: Parameter? { nil }
    init(userID: UserID, lastQuestionID: QuestionID?, size: Int) {
        self.userID = userID
        self.lastQuestionID = lastQuestionID
        self.size = size
    }
}
