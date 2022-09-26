//
//  DeleteQuestionRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/26.
//

import Foundation

struct DeleteQuestionRequest: Requestable {
    var path: String { "/api/v1/questions/\(self.questionID)"}
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .delete }
    
    private let questionID: QuestionID
    
    init(
        questionID: QuestionID
    ) {
        self.questionID = questionID
    }
}
