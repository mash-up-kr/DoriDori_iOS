//
//  MyPageMySpeechBubbleCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/31.
//

import UIKit

struct MyPageMySpeechBubbleCellItem: MyPageMySpeechBubbleViewItemType,
                                     MyPageBubbleItemType {
    let questioner: String
    let userName: String
    let content: String
    let location: String
    let updatedTime: Int
    let likeCount: Int
    let profileImageURL: URL?
    let level: Int
}

final class MyPageMySpeechBubbleCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
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
    private let speechBubble = MyPageMySpeechBubbleView()
    
    // MARK: - Init
    
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
    
    func configure(_ item: MyPageMySpeechBubbleCellItem) {
        self.speechBubble.configure(item)
        if let imageURL = item.profileImageURL {
            self.profileImageView.kf.setImage(with: imageURL)
        }
        self.levelView.configure(level: item.level)
    }
    
    static func fittingSize(width: CGFloat, item: MyPageMySpeechBubbleCellItem) -> CGSize {
        let cell = MyPageMySpeechBubbleCell()
        cell.configure(item)
        let targetSize = CGSize(width: width,
                                height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .required,
                                                        verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - Private functions

extension MyPageMySpeechBubbleCell {
    
    private func setupLayouts() {
        self.contentView.addSubViews(self.speechBubble, self.profileImageView, self.levelView)
   
        self.speechBubble.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview()
        }
        
        self.profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(42)
            $0.leading.equalTo(self.speechBubble.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(30)
        }
     
        self.levelView.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(self.profileImageView.snp.centerX)
        }
    }
}
