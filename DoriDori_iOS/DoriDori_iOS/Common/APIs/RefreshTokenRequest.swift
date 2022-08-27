//
//  RefreshTokenRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/23.
//

import Foundation

struct RefreshTokenRequest: Requestable {
    var path: String { "/api/v1/auth/issue/token" }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var parameters: Parameter? {
        ["refreshToken": UserDefaults.refreshToken]
    }
    var method: HTTPMethod { .post }
}
