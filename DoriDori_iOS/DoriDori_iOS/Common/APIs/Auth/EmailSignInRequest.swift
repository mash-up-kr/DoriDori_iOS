//
//  EmailSignInRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/22.
//

import Foundation

struct EmailSignInRequest: Requestable {
    
    private let email: String
    private let password: String
    private let loginType: String
    
    var path: String { "/api/v1/auth/login" }
    var parameters: Parameter? { [ "email": email, "loginType": loginType, "password": password ] }
    var method: HTTPMethod = .post
    var encoding: ParameterEncoding { JSONEncoding.default }

    init(email: String, loginType: String, password: String) {
        self.email = email
        self.loginType = loginType
        self.password = password
    }
}
