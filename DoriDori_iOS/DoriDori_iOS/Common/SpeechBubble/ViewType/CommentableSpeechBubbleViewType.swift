//
//  CommentableSpeechBubbleViewType.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import UIKit

protocol CommentableSpeechBubbleViewType where Self: SpeechBubbleViewType {
    func setupCommentButton(_ count: Int, at button: UIButton)
    var commentTitle: String { get }
}

extension CommentableSpeechBubbleViewType {
    var commentTitle: String { "댓글" }
    func setupCommentButton(_ count: Int, at button: UIButton) {
        let buttonTitle: String
        if count == 0 { buttonTitle = self.commentTitle }
        else { buttonTitle = count.decimalString ?? "0" }
        
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
    }
}
