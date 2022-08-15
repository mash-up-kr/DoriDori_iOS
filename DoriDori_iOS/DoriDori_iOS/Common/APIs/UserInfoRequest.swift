//
//  UserInfoRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import Foundation

struct UserInfoRequest: Requestable {
    private let userID: UserID
    var path: String { "/api/v1/user/\(self.userID)/info" }
    var parameters: Parameter? { nil }
    init(userID: UserID) {
        self.userID = userID
    }
}
