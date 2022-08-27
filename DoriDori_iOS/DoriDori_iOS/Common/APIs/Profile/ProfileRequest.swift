//
//  ProfileRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/27.
//

import Foundation

struct ProfileRequest: Requestable {
    private let description: String
    private let tags: [String]
    private let representativeWardId: String?
    
    var path: String { "/api/v1/user/nickname" }
    var parameters: Parameter? { ["description": description, "tags": tags, "representativeWardId": representativeWardId ?? ""] }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var method: HTTPMethod = .post
    
    init(description: String, tags: [String], representativeWardId: String?) {
        self.description = description
        self.tags = tags
        self.representativeWardId = representativeWardId
    }
}
