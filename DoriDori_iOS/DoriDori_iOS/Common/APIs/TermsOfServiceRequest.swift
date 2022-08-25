//
//  TermsOfServiceRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/23.
//

import Foundation

struct TermsOfServiceRequest: Requestable {
    
    var path: String { "/api/v1/terms" }
    var parameters: Parameter? { nil }
    init() {
        
    }
}
