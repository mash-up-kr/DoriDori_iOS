//
//  QuestionToUserRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import Foundation

struct QuestionToUserRequest: Requestable {
    private let content: String
    private let longitude: Double
    private let latitude: Double
    private let anonymous: Bool
    private let userID: UserID
    
    var encoding: ParameterEncoding { JSONEncoding.default }
    var method: HTTPMethod { .post }
    var path: String { "/api/v1/questions" }
    var parameters: Parameter? {
        [
            "userId": self.userID,
            "content": self.content,
            "longitude": self.longitude,
            "latitude": self.latitude,
            "anonymous": self.anonymous
        ]
    }
    
    init(
        userID: UserID,
        content: String,
        longtitude: Double,
        latitude: Double,
        anonymous: Bool
    ) {
        self.userID = userID
        self.content = content
        self.longitude = longtitude
        self.latitude = latitude
        self.anonymous = anonymous
    }
}
