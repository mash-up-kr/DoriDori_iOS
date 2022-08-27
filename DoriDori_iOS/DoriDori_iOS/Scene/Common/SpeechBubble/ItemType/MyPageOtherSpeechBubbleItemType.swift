//
//  MyPageOtherSpeechBubbleItemType.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import Foundation

protocol MyPageOtherSpeechBubbleItemType: MyPageBubbleItemType {
    var content: String { get }
    var location: String { get }
    var updatedTime: Int { get }
    var tags: [String] { get }
    var userName: String { get }
}
