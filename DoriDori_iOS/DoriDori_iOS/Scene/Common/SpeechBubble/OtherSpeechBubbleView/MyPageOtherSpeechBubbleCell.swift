//
//  MyPageOtherSpeechBubbleCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/23.
//

import UIKit
import Kingfisher
import RxSwift
import RxRelay
import RxGesture

struct IdentifiedMyPageSpeechBubbleCellItem: IdentifiedMyPageSpeechBubbleCellItemType {
    let userID: UserID
    let questionID: QuestionID
    let content: String
    let location: String
    let updatedTime: Int
    let level: Int
    let imageURL: URL?
    let tags: [String]
    let userName: String
}

struct AnonymousMyPageSpeechBubbleCellItem: AnonymousMyPageSpeechBubbleCellItemType {
    let userID: UserID
    let questionID: QuestionID
    let content: String
    let location: String
    let updatedTime: Int
    let tags: [String]
    let userName: String
}

protocol IdentifiedMyPageSpeechBubbleCellItemType: MyPageOtherSpeechBubbleItemType {
    var level: Int { get }
    var imageURL: URL? { get }
}

protocol AnonymousMyPageSpeechBubbleCellItemType: MyPageOtherSpeechBubbleItemType {
}

final class MyPageOtherSpeechBubbleCell: UICollectionViewCell {
        
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
    private let speechBubble = MyPageOtherSpeechBubbleView()
    
    private var disposeBag = DisposeBag()
    
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
        self.disposeBag = .init()
    }
    
    func configure(_ item: MyPageOtherSpeechBubbleItemType, shouldHideButtonstackView: Bool = true) {
        self.speechBubble.configure(item, shouldHideButtonstackView: shouldHideButtonstackView)
        if let identifiedMyPageSpeechBubbleCellItem = item as? IdentifiedMyPageSpeechBubbleCellItem {
            self.profileImageView.kf.setImage(with: identifiedMyPageSpeechBubbleCellItem.imageURL)
            self.levelView.configure(level: identifiedMyPageSpeechBubbleCellItem.level)
        }
        if let _ = item as? AnonymousMyPageSpeechBubbleCellItem {
            self.levelView.isHidden = true
        }
    }
    
    func bindAction(didTapProfile: PublishRelay<IndexPath>, at indexPath: IndexPath) {
        self.profileImageView.rx.tapGesture()
            .when(.recognized)
            .map { _ in return indexPath }
            .bind(to: didTapProfile)
            .disposed(by: self.disposeBag)
    }
    
    static func fittingSize(width: CGFloat, item: MyPageOtherSpeechBubbleItemType, shouldHideButtonstackView: Bool = true) -> CGSize {
        let cell = MyPageOtherSpeechBubbleCell()
        cell.configure(item, shouldHideButtonstackView: shouldHideButtonstackView)
        let targetSize = CGSize(width: width,
                                height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .required,
                                                        verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - Private functions

extension MyPageOtherSpeechBubbleCell {
    
    private func setupLayouts() {
        self.contentView.addSubViews(self.profileImageView, self.levelView, self.speechBubble)
        self.profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(42)
        }
        self.levelView.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(7)
            $0.centerX.equalTo(self.profileImageView)
            $0.height.equalTo(18)
        }
        self.speechBubble.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
