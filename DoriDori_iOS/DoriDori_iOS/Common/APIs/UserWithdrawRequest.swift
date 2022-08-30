//
//  UserWithdrawRequest.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/30.
//

import Foundation

struct UserWithdrawRequest: Requestable {
    var path: String { "/api/v1/user" }
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .delete }
}
