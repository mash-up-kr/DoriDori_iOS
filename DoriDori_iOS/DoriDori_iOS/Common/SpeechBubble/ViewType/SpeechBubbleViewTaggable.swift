//
//  SpeechBubbleViewTaggable.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import Foundation

protocol SpeechBubbleViewTaggable where Self: SpeechBubbleViewType {
    func configureTagViews(_ tags: [String]) -> [KeywordView]
}

extension SpeechBubbleViewTaggable {
    func configureTagViews(_ tags: [String]) -> [KeywordView] {
        return tags.map { KeywordView(title: $0) }
    }
}
