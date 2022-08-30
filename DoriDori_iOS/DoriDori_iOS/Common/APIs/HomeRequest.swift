//
//  HomeRequest.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/27.
//

import Foundation

struct HomeLikeRequest: Requestable {
    var path: String { "/api/v1/posts/\(id)/like" }
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .post }
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
}

struct HomeDislikeRequest: Requestable {
    var path: String { "/api/v1/posts/\(id)/like" }
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .delete }
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
}

struct HomeCommentRequest: Requestable {
    var path: String { "/ap1/v1/posts/\(postId)/comment"}
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .get }
    
    private let postId: String
    
    init(postId: String) {
        self.postId = postId
    }
}
