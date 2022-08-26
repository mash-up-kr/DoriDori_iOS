//
//  EmailSignUpRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/26.
//

import Foundation

struct EmailSignUpRequest: Requestable {
    
    private let email: String
    private let password: String
    private let termsIds: [String]
    
    var path: String { "https://doridori.ga/api/v1/user/join" }
    var parameters: Parameter? { ["email": email, "password": password, "termsIds": termsIds] }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var method: HTTPMethod = .post
    
    init(email: String, password: String, termsIds: [String]) {
        self.email = email
        self.password = password
        self.termsIds = termsIds
    }
    
}
