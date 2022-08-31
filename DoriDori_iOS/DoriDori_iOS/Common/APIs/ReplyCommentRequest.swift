//
//  ReplyCommentRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/31.
//

import Foundation

struct ReplyCommentRequest: Requestable {
    private let questionID: QuestionID
    private let content: String
    private let location: Location
    var path: String { "/api/v1/questions/\(self.questionID)/answer"}
    var method: HTTPMethod { .post }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var parameters: Parameter? {
        [
            "content": content,
            "longitude": location.longitude,
            "latitude": location.latitude
        ]
    }
    
    init(
        questionID: QuestionID,
        content: String,
        location: Location
    ) {
        self.questionID = questionID
        self.content = content
        self.location = location
    }
}
