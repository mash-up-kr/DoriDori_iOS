//
//  ProfileDefaultReqeust.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/29.
//

import Foundation

struct ProfileDefaultReqeust: Requestable {
    var path: String { "/api/v1/user/profile/image/default" }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var parameters: Parameter?
    var method: HTTPMethod = .post
}
