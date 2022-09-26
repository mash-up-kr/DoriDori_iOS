//
//  BlockUserRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/26.
//

import Foundation

struct BlockUserRequest: Requestable {
    var path: String { "/api/v1/user/block/\(self.userID)"}
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .post }
    private let userID: UserID
    
    init(
        userID: UserID
    ) {
        self.userID = userID
    }
}
