//
//  DeletePostRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/26.
//

import Foundation

struct DeletePostRequest: Requestable {
    var path: String { "/api/v1/posts/\(self.postID)"}
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .delete }
    private let postID: PostID
    init(
        postID: PostID
    ) {
        self.postID = postID
    }
}
