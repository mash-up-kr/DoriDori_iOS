//
//  QuestionDenyRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import Foundation

struct QuestionDenyRequest: Requestable {
    private let questionID: String
    var path: String { "/api/v1/questions/\(self.questionID)/deny" }
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .post }
    
    init(questionID: String) {
        self.questionID = questionID
    }
}
