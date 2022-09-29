//
//  DeleteAnswerRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/29.
//

import Foundation

struct DeleteAnswerRequest: Requestable {
    private let answerID: AnswerID
    
    var method: HTTPMethod { .delete }
    var parameters: Parameter? { nil }
    var path: String { "/api/v1/answers/\(self.answerID)" }
    
    init(
        answerID: AnswerID
    ) {
        self.answerID = answerID
    }
}
