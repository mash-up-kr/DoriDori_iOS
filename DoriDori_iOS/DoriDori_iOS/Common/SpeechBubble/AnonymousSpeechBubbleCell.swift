//
//  AnonymousSpeechBubbleCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/23.
//

import UIKit

struct AnonymousSpeechBubbleCellItem: AnonymousSpeechBubbleCellItemType {
    let text: String
    let location: String
    let updatedTime: Int
}

protocol AnonymousSpeechBubbleCellItemType: AnonymousSpeechBubbleItemType {
}

final class AnonymousSpeechBubbleCell: UICollectionViewCell {
        
    // MARK: UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "maedori3")
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray800.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    private let speechBubble = AnonymousSpeechBubble()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(_ item: AnonymousSpeechBubbleCellItemType) {
        self.speechBubble.configure(item)
    }
}

// MARK: - Private functions

extension AnonymousSpeechBubbleCell {
    
    private func setupLayouts() {
        self.contentView.addSubViews(views: self.profileImageView, self.speechBubble)
        self.profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(42)
        }
        self.speechBubble.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
