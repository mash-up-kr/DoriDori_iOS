//
//  QuestionAtCommunityRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import Foundation

struct QuestionAtCommunityRequest: Requestable {
    private let content: String
    private let longitude: Double
    private let latitude: Double
    private let anonymous: Bool
    
    var method: HTTPMethod { .post }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var path: String { "/api/v1/posts" }
    var parameters: Parameter? {
        [
            "content": self.content,
            "longitude": self.longitude,
            "latitude": self.latitude,
            "anonymous": self.anonymous
        ]
    }
    
    init(
        content: String,
        longtitude: Double,
        latitude: Double,
        anonymous: Bool
    ) {
        self.content = content
        self.longitude = longtitude
        self.latitude = latitude
        self.anonymous = anonymous
    }
}
