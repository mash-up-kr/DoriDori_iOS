//
//  HomeOtherSpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/24.
//

import UIKit

protocol HomeOtherSpeechBubbleItemType {
    var content: String { get }
    var userNmae: String { get }
    var location: String { get }
    var updatedTime: Int { get }
    var likeCount: Int { get }
    var commentCount: Int { get }
    var tags: [String] { get }
}

final class HomeOtherSpeechBubbleView: OtherSpeechBubbleView {
    
    // MARK: - UIComponent
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray200
        label.font = UIFont.setKRFont(weight: .medium, size: 13)
        return label
    }()
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .medium, size: 16)
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray600
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    private let verticalSeperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray700
        return view
    }()
    private let updatedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray600
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    private let locationTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    private let horizontalSeperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray800
        return view
    }()
    private let handButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private let buttonSeperaterView1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chat"), for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return button
    }()
    private let buttonSeperaterView2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reply"), for: .normal)
        button.setTitle("공유", for: .normal)
        button.setTitleColor(UIColor.gray500, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return button
    }()
    
    override init(
        borderWidth: CGFloat = 1,
        borderColor: UIColor = .gray500,
        backgroundColor: UIColor = .gray900
    ) {
        super.init(
            borderWidth: borderWidth,
            borderColor: borderColor,
            backgroundColor: backgroundColor
        )
        self.setupLayouts()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: HomeOtherSpeechBubbleItemType) {
        self.setupContent(item.content)
        self.locationLabel.text = item.location
        self.updatedTimeLabel.text = "\(item.updatedTime)분 전"
        self.userNameLabel.text = item.userNmae
        self.setupHandButton(item.likeCount)
        self.setupCommentButton(item.commentCount)
        self.setupTagView(item.tags)
    }
    
    private func setupContent(_ content: String) {
        let textParagraphStype = NSMutableParagraphStyle()
        textParagraphStype.maximumLineHeight = 25
        textParagraphStype.minimumLineHeight = 25
        textParagraphStype.lineBreakMode = .byCharWrapping
        self.contentLabel.attributedText = NSMutableAttributedString(string: content, attributes: [
            .font: UIFont.setKRFont(weight: .medium, size: 16),
            .paragraphStyle: textParagraphStype,
            .foregroundColor: UIColor.white
        ])
    }
    
    private func setupTagView(_ tags: [String]) {
        if tags.isEmpty { self.tagStackView.isHidden = true }
        tags.forEach { tag in
            let tagView = KeywordView(title: tag)
            self.tagStackView.addArrangedSubview(tagView)
        }
    }
    
    private func setupHandButton(_ count: Int) {
        if count == 0 {
            self.handButton.setImage(UIImage(named: "hand_off"), for: .normal)
            self.handButton.setTitle("궁금해요", for: .normal)
            self.handButton.setTitleColor(.gray500, for: .normal)
            self.handButton.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 12)
            self.handButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 4)
        }
        else {
            self.handButton.setImage(UIImage(named: "hand"), for: .normal)
            self.handButton.setTitle(count.decimalString ?? "0", for: .normal)
            self.handButton.setTitleColor(.lime300, for: .normal)
            self.handButton.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
            self.handButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 4)
        }
    }
    
    private func setupCommentButton(_ count: Int) {
        let buttonTitle: String
        if count == 0 { buttonTitle = "댓글" }
        else { buttonTitle = count.decimalString ?? "0" }
        self.commentButton.setTitle(buttonTitle, for: .normal)
        self.commentButton.setTitleColor(.gray500, for: .normal)
        self.commentButton.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
    }
    
    private func setupLayouts() {
      
        self.addSubViews(
            views: self.userNameLabel,
            self.moreButton,
            self.tagStackView,
            self.contentLabel,
            self.locationTimeStackView,
            self.horizontalSeperatedView,
            self.handButton,
            self.buttonSeperaterView1,
            self.commentButton,
            self.buttonSeperaterView2,
            self.shareButton
        )
        
        self.locationTimeStackView.addArrangedSubViews(
            self.locationLabel,
            self.verticalSeperatedView,
            self.updatedTimeLabel
        )
        self.locationLabel.snp.makeConstraints { $0.height.equalTo(16) }
        self.verticalSeperatedView.snp.makeConstraints {
            $0.height.equalTo(10)
            $0.width.equalTo(1)
        }
        self.updatedTimeLabel.snp.makeConstraints { $0.height.equalTo(16) }
        
        self.userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(26)
        }
        self.moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(24)
        }
        self.tagStackView.snp.makeConstraints {
            $0.top.equalTo(self.userNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
        }
        self.contentLabel.snp.makeConstraints {
            $0.leading.equalTo(self.userNameLabel.snp.leading)
            $0.top.equalTo(self.tagStackView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        self.locationTimeStackView.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(16)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
        }
        self.horizontalSeperatedView.snp.makeConstraints {
            $0.top.equalTo(self.locationTimeStackView.snp.bottom).offset(12)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        let speechBubbleWidth = UIScreen.main.bounds.width - 30 - 42 - 8 - 30 - 10 - 2
        self.handButton.snp.makeConstraints {
            $0.top.equalTo(self.horizontalSeperatedView.snp.bottom)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(speechBubbleWidth / 3)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview()
        }
        self.buttonSeperaterView1.snp.makeConstraints {
            $0.centerY.equalTo(self.commentButton)
            $0.leading.equalTo(self.handButton.snp.trailing)
            $0.width.equalTo(1)
            $0.height.equalTo(24)
        }
        self.commentButton.snp.makeConstraints{
            $0.top.equalTo(self.horizontalSeperatedView.snp.bottom)
            $0.leading.equalTo(self.buttonSeperaterView1.snp.trailing)
            $0.width.equalTo(speechBubbleWidth / 3)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        self.buttonSeperaterView2.snp.makeConstraints {
            $0.centerY.equalTo(self.commentButton)
            $0.leading.equalTo(self.commentButton.snp.trailing)
            $0.width.equalTo(1)
            $0.height.equalTo(24)
        }
        self.shareButton.snp.makeConstraints {
            $0.top.equalTo(self.horizontalSeperatedView.snp.bottom)
            $0.leading.equalTo(self.buttonSeperaterView2.snp.trailing)
            $0.width.equalTo(speechBubbleWidth / 3)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
}
