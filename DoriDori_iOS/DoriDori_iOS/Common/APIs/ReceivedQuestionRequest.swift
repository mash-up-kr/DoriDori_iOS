//
//  ReceivedQuestionRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/30.
//

import Foundation

struct ReceivedQuestionRequest: Requestable {
    private let size: Int
    private let lastID: QuestionID?
    var path: String {
        "/api/v1/user/received-questions"
    }
    
    var parameters: Parameter? {
        var params: [String: Any] = ["size": self.size]
        if let lastID = self.lastID {
            params["lastId"] = lastID
        }
        return params
    }
    
    init(
        size: Int,
        lastID: QuestionID?
    ) {
        self.size = size
        self.lastID = lastID
    }
}
