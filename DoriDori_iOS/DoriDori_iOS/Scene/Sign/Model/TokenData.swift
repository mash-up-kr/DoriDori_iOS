//
//  TokenData.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/22.
//

import Foundation

struct TokenData: Codable {
    let accessToken: String?
    let refreshToken: String
    let userId: String
}
