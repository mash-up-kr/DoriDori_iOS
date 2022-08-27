//
//  HomeMySpeechBubbleViewCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import UIKit

final class HomeMySpeechBubbleViewCell: UICollectionViewCell {
    
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
    private let speechBubble = HomeMySpeechBubbleView()
    static let identifier = "HomeMySpeechBubbleViewCell"
    
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
    
    func configure(item: HomeSpeechInfo) {
        speechBubble.configure(item)
        profileImageView.kf.setImage(with: URL(string: item.user.profileImageURL))
        levelView.configure(level: item.user.level)
    }
    
    static func fittingSize(width: CGFloat, item: HomeSpeechInfo) -> CGSize {
        let cell = HomeMySpeechBubbleViewCell()
        cell.configure(item: item)
        let targetSize = CGSize(
            width: width,
            height: UIView.layoutFittingCompressedSize.height
        )
        return cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .required,
                                                        verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - HomeMySpeechBubbleViewCell

extension HomeMySpeechBubbleViewCell {
    private func setupLayouts() {
        self.contentView.addSubViews(self.profileImageView, self.levelView, self.speechBubble)
        self.speechBubble.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        self.profileImageView.snp.makeConstraints {
            $0.leading.equalTo(self.speechBubble.snp.trailing).offset(18)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(42)
            $0.trailing.equalToSuperview().inset(30)
        }
        self.levelView.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(7)
            $0.centerX.equalTo(self.profileImageView)
            $0.height.equalTo(18)
        }
   
    }
}
