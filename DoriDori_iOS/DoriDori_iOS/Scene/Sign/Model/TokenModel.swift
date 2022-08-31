//
//  TokenModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/27.
//

import Foundation

struct TokenModel: Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String
}
