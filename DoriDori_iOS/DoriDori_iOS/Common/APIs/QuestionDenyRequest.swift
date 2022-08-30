//
//  QuestionDenyRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/30.
//

import Foundation

struct QuestionDenyRequest: Requestable {
    var path: String { "/api/v1/questions/\(self.questionID)/deny" }
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .post }
    
    private let questionID: QuestionID
    init(questionID: QuestionID) {
        self.questionID = questionID
    }
}
