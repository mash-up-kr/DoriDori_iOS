//
//  NicknameRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/27.
//

import Foundation

struct NicknameRequest: Requestable {
    private let nickname: String
    var path: String { "/api/v1/user/nickname" }
    var parameters: Parameter? { ["nickname": nickname] }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var method: HTTPMethod = .post
    
    init(nickname: String) {
        self.nickname = nickname
    }
    
}
