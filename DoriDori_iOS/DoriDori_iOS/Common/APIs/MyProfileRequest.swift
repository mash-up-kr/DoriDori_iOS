//
//  MyProfileRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/29.
//

import Foundation

struct MyProfileRequest: Requestable {
    var path: String { "/api/v1/user/me" }
    var parameters: Parameter? { nil }
}
