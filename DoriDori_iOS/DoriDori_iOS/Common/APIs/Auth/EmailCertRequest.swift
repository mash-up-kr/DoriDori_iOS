//
//  EmailCertRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/25.
//

import Foundation

struct EmailCertRequest: Requestable {
    var headers: HTTPHeaders?
    
    private let email: String
    private let certificationNumber: String
    
    var path: String { "/api/v1/auth/mail/cert" }
    var parameters: Parameter? { [ "email": email , "certificationNumber": certificationNumber] }
    var method: HTTPMethod = .post

    init(email: String, certificationNumber: String) {
        self.email = email
        self.certificationNumber = certificationNumber
    }
}
