//
//  LikeableSpeechBubbleViewType.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/03.
//

import UIKit

enum LikeButtonType {
    case hand
    case heart
}

protocol LikeableSpeechBubbleViewType where Self: SpeechBubbleViewType {
    var likeButtonType: LikeButtonType { get }
    func setupLikeButton(_ count: Int, at button: UIButton)
}

extension LikeableSpeechBubbleViewType {
    private func likeButtonImage(_ type: LikeButtonType) -> UIImage? {
        switch self.likeButtonType {
        case .heart: return UIImage(named: "heart")
        case .hand: return UIImage(named: "hand")
        }
    }
    
    func setupLikeButton(_ count: Int, at button: UIButton) {
        let image = self.likeButtonImage(self.likeButtonType)
        
        if count == 0 {
            button.setImage(image?.withTintColor(.gray600), for: .normal)
            button.setTitle("궁금해요", for: .normal)
            button.setTitleColor(.gray500, for: .normal)
            button.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 12)
            button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 4)
        }
        else {
            button.setImage(image, for: .normal)
            button.setTitle(count.decimalString ?? "0", for: .normal)
            button.setTitleColor(.lime300, for: .normal)
            button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
            button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 4)
        }
    }
}
