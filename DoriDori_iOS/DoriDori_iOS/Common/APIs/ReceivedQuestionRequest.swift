//
//  ReceivedQuestionRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/15.
//

import Foundation

struct ReceivedQuestionRequest: Requestable {
    private let size: Int
    var path: String { "/api/v1/user/received-questions" }
    var parameters: Parameter? { ["size": self.size] }
    init(size: Int) {
        self.size = size
    }
}
