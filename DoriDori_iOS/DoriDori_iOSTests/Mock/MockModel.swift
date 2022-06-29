//
//  MockModel.swift
//  DoriDori_iOSTests
//
//  Created by Seori on 2022/06/30.
//

import Foundation
@testable import DoriDori_iOS

struct FakeRequest: Requestable {
    let url: String
    let parameters: [String : Any]?
    let method: HTTPMethod
    
    init(
        url: String,
        parameters: [String: Any]?,
        method: HTTPMethod
    ) {
        self.url = url
        self.parameters = parameters
        self.method = method
    }
}

struct FakeModel: Decodable {
    let fake: String
}
