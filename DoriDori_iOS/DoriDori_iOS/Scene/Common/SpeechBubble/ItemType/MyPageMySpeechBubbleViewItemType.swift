//
//  MyPageMySpeechBubbleViewItemType.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import Foundation

protocol MyPageMySpeechBubbleViewItemType {
    var questioner: String { get }
    var userName: String { get }
    var content: String { get }
    var location: String { get }
    var updatedTime: Int { get }
    var likeCount: Int { get }
}
