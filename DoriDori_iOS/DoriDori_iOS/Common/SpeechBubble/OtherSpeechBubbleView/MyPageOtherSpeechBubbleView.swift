//
//  MyPageOtherSpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/23.
//

import UIKit

final class MyPageOtherSpeechBubbleView: OtherSpeechBubbleView,
                                         SpeechBubbleViewType,
                                         SpeechBubbleViewTaggable {

    // MARK: - UIComponent
    
    private let nameLabel: UILabel = {
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
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.setKRFont(weight: .medium, size: 16)
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
        view.backgroundColor = .gray800
        return view
    }()
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.setTitle("답변하기", for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
        button.setTitleColor(UIColor.blue300, for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        return button
    }()
    private let buttonSeperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray700
        return view
    }()
    private let refuseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refuse"), for: .normal)
        button.setTitle("거절하기", for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
        button.setTitleColor(UIColor.gray500, for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        return button
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Init
    
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

// MARK: - Private functions

extension MyPageOtherSpeechBubbleView {
    
    func configure(_ item: MyPageOtherSpeechBubbleItemType) {
        self.nameLabel.text = item.userName
        self.locationLabel.text = item.location
        self.updatedTimeLabel.text = "\(item.updatedTime)분 전"
        self.setupTagStackView(item.tags)
        self.setupContentLabel(item.content, at: self.contentLabel)
    }

    private func setupTagStackView(_ tags: [String]) {
        let tagViews = self.configureTagViews(tags)
        self.tagStackView.isHidden = tagViews.isEmpty
        tagViews.forEach(self.tagStackView.addArrangedSubview(_:))
    }
}

// MARK: - Layouts

extension MyPageOtherSpeechBubbleView {
    
    private func setupLayouts() {
        self.locationTimeStackView.addArrangedSubViews(self.locationLabel, self.verticalSeperatedView, self.updatedTimeLabel)
        self.buttonStackView.addArrangedSubViews(self.commentButton, self.buttonSeperatedView, self.refuseButton)
        self.addSubViews(
            self.nameLabel,
            self.moreButton,
            self.tagStackView,
            self.contentLabel,
            self.locationTimeStackView,
            self.horizontalSeperatedView,
            self.buttonStackView
        )
        
        self.commentButton.snp.makeConstraints { $0.height.equalTo(40) }
        self.buttonSeperatedView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(1)
        }
        self.refuseButton.snp.makeConstraints { $0.height.equalTo(40) }
        self.locationLabel.snp.makeConstraints { $0.height.equalTo(16) }
        self.verticalSeperatedView.snp.makeConstraints {
            $0.height.equalTo(10)
            $0.width.equalTo(1)
        }
        self.updatedTimeLabel.snp.makeConstraints { $0.height.equalTo(16) }
        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(26)
        }
        self.moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(24)
        }
        self.tagStackView.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(self.nameLabel.snp.leading)
        }
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.tagStackView.snp.bottom).offset(16)
            $0.leading.equalTo(self.nameLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
        }
        self.locationTimeStackView.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(16)
            $0.leading.equalTo(self.nameLabel.snp.leading)
        }
        self.horizontalSeperatedView.snp.makeConstraints {
            $0.top.equalTo(self.locationTimeStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(self.contentLabel)
            $0.height.equalTo(1)
        }
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalTo(self.horizontalSeperatedView.snp.bottom)
            $0.leading.trailing.equalTo(self.contentLabel)
            $0.bottom.equalToSuperview()
        }
    }
}
