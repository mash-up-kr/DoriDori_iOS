//
//  HomeMySpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import UIKit

final class HomeMySpeechBubbleView: MySpeechBubbleView {
    
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
    private let handStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
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
    private let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let buttonSeperatorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
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
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    override init(
        borderWidth: CGFloat = 1,
        borderColor: UIColor = .gray900,
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
}

extension HomeMySpeechBubbleView {
    
    func configure(_ item: HomeSpeechBubbleItemType) {
        self.setupContent(item.content)
        self.locationLabel.text = item.location
        self.updatedTimeLabel.text = "\(item.updatedTime)분 전"
        self.userNameLabel.text = item.userName
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
}

// MARK: - Layouts

extension HomeMySpeechBubbleView {
    
    private func setupLayouts() {
      
        self.addSubViews(
            self.userNameLabel,
            self.moreButton,
            self.tagStackView,
            self.contentLabel,
            self.locationTimeStackView,
            self.horizontalSeperatedView,
            self.buttonStackView
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
            $0.leading.equalToSuperview().offset(16)
        }
        self.moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(24)
        }
        self.tagStackView.snp.makeConstraints {
            $0.top.equalTo(self.userNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
        }
        self.contentLabel.snp.makeConstraints {
            $0.leading.equalTo(self.userNameLabel.snp.leading)
            $0.top.equalTo(self.tagStackView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(26)
        }
        self.locationTimeStackView.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(16)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
        }
        self.horizontalSeperatedView.snp.makeConstraints {
            $0.top.equalTo(self.locationTimeStackView.snp.bottom).offset(12)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(1)
        }
        
        self.layoutsButtons()
    }
    
    private func layoutsButtons() {
        self.handStackView.addArrangedSubViews(self.handButton, self.buttonSeperaterView1)
        self.commentStackView.addArrangedSubViews(self.commentButton, self.buttonSeperaterView2)
        self.buttonStackView.addArrangedSubViews(self.handStackView, self.commentStackView, self.shareButton)
        [self.handButton, self.commentButton, self.shareButton].forEach { button in
            button.snp.makeConstraints { $0.height.equalTo(40) }
        }
        [self.buttonSeperaterView1, self.buttonSeperaterView2].forEach { seperatorView in
            seperatorView.snp.makeConstraints {
                $0.width.equalTo(1)
                $0.height.equalTo(24)
                $0.centerY.equalToSuperview()
            }
        }
        
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalTo(self.horizontalSeperatedView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }
}
