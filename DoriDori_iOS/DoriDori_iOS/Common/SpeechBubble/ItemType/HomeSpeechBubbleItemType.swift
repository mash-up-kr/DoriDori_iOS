//
//  HomeSpeechBubbleItemType.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import Foundation

protocol HomeSpeechBubbleItemType {
    var content: String { get }
    var userName: String { get }
    var location: String { get }
    var updatedTime: Int { get }
    var likeCount: Int { get }
    var commentCount: Int { get }
    var tags: [String] { get }
}
