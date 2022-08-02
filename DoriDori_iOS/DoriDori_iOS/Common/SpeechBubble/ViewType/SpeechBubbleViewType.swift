//
//  SpeechBubbleViewType.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import UIKit

protocol SpeechBubbleViewType: AnyObject {
    func setupContentLabel(_ content: String, at label: UILabel)
}

extension SpeechBubbleViewType {
    func setupContentLabel(_ content: String, at label: UILabel) {
        let textParagraphStype = NSMutableParagraphStyle()
        textParagraphStype.maximumLineHeight = 25
        textParagraphStype.minimumLineHeight = 25
        label.attributedText = NSMutableAttributedString(string: content, attributes: [
            .font: UIFont.setKRFont(weight: .medium, size: 16),
            .paragraphStyle: textParagraphStype,
            .foregroundColor: UIColor.white
        ])
    }
}
