//
//  EmailSignUpRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/15.
//

import Foundation

struct EmailSendRequest: Requestable {
    
    private let email: String
    var path: String { "/api/v1/auth/mail/send" }
    var parameters: Parameter? { [ "email": email ] }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var method: HTTPMethod = .post
    
    init(email: String) {
        self.email = email
    }
}
