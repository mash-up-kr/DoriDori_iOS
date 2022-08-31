//
//  EmailSignUpModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/26.
//

import Foundation

struct EmailSignUpModel: Codable {
    var email: String
    var password: String
    var termsIds: [String]
}
