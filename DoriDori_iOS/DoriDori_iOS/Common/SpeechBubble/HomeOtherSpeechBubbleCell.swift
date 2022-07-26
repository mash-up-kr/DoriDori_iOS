//
//  HomeOtherSpeechBubbleCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/25.
//

import UIKit

struct HomeOtherSpeechBubbleCellItem: HomeOtherSpeechBubbleCellItemType {
    let level: Int
    let location: String
    let updatedTime: Int
    let profileImageURL: String
    let content: String
    let userNmae: String
    let likeCount: Int
    let commentCount: Int
    let tags: [String]
}

protocol HomeOtherSpeechBubbleCellItemType: HomeOtherSpeechBubbleItemType {
    var profileImageURL: String { get }
    var level: Int { get }
}

final class HomeOtherSpeechBubbleCell: UICollectionViewCell {
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
    private let levelView = LevelView()
    private let speechBubble = HomeOtherSpeechBubbleView()
    
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
    
    
    func configure(_ item: HomeOtherSpeechBubbleCellItemType) {
        self.levelView.configure(level: item.level)
        self.speechBubble.configure(item)
    }
    
    static func fittingSize<Item: HomeOtherSpeechBubbleCellItemType>(width: CGFloat, item: Item) -> CGSize {
        let cell = HomeOtherSpeechBubbleCell()
        cell.configure(item)
        let targetSize = CGSize(width: width,
                                height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .required,
                                                        verticalFittingPriority: .fittingSizeLevel)
    }
}

extension HomeOtherSpeechBubbleCell {
    
    private func setupLayouts() {
        self.contentView.addSubViews(views: self.profileImageView, self.levelView, self.speechBubble)
        self.profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(42)
        }
        self.levelView.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(self.profileImageView)
        }
        self.speechBubble.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
