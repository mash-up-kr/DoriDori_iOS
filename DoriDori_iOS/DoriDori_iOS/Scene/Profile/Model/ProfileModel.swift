//
//  ProfileModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/27.
//

import Foundation

struct ProfileModel: Codable {
    let description: String
    let tags: [String]
}

struct NicknameModel: Codable {
    let nickname: String
}
