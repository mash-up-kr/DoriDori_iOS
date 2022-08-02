//
//  MyPageMySpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/31.
//

import UIKit

final class MyPageMySpeechBubbleView: MySpeechBubbleView,
                                      SpeechBubbleViewType,
                                      SpeechBubbleViewLikeable {
    
    // MARK: - UIComponent
    
    private let questionerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .medium, size: 13)
        label.textColor = UIColor.gray200
        return label
    }()
    private let bracketImageView: UIImageView = {
        let bracketImageView = UIImageView(image: UIImage(named: "right_bracket"))
        return bracketImageView
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .medium, size: 13)
        label.textColor = UIColor.lime300
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
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
    
    private let horizontalSeperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray800
        return view
    }()
    private let likeButton = UIButton()
    private let buttonSeperaterView: UIView = {
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
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Properties
    
    var likeButtonType: LikeButtonType { .heart }
    
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
    
    func configure(_ item: MyPageMySpeechBubbleViewItemType) {
        self.questionerNameLabel.text = item.questioner
        self.userNameLabel.text = item.userName
        self.locationLabel.text = item.location
        self.updatedTimeLabel.text = "\(item.updatedTime)분 전"
        self.setupContentLabel(item.content, at: self.contentLabel)
        self.setupLikeButton(item.likeCount, at: self.likeButton)
    }
}

// MARK: - Layouts

extension MyPageMySpeechBubbleView {
    
    private func setupLayouts() {
        self.addSubViews(
            self.questionerNameLabel,
            self.bracketImageView,
            self.userNameLabel,
            self.moreButton,
            self.contentLabel,
            self.locationLabel,
            self.verticalSeperatedView,
            self.updatedTimeLabel,
            self.horizontalSeperatedView,
            self.buttonStackView
        )
        self.layoutsUserInfo()
        self.moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.greaterThanOrEqualTo(self.userNameLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(24)
        }
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.questionerNameLabel.snp.bottom).offset(18)
            $0.leading.equalTo(self.questionerNameLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(26)
        }
        self.layoutsLocationAndTime()
        self.horizontalSeperatedView.snp.makeConstraints {
            $0.top.equalTo(self.locationLabel.snp.bottom).offset(16)
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(self.contentLabel)
        }
        self.layoutsButtons()
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalTo(self.horizontalSeperatedView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layoutsUserInfo() {
        
        self.questionerNameLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalToSuperview().offset(18)
        }
        self.bracketImageView.snp.makeConstraints {
            $0.leading.equalTo(self.questionerNameLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(self.questionerNameLabel.snp.centerY)
            $0.width.equalTo(4)
            $0.height.equalTo(8)
        }
        self.userNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.questionerNameLabel.snp.top)
            $0.leading.equalTo(self.bracketImageView.snp.trailing).offset(8)
            $0.height.equalTo(18)
        }
    }
    
    private func layoutsLocationAndTime() {
        
           self.locationLabel.snp.makeConstraints {
               $0.height.equalTo(16)
               $0.leading.equalToSuperview().offset(16)
               $0.top.equalTo(self.contentLabel.snp.bottom).offset(18)
           }
           self.verticalSeperatedView.snp.makeConstraints {
               $0.centerY.equalTo(self.locationLabel.snp.centerY)
               $0.height.equalTo(10)
               $0.width.equalTo(1)
               $0.leading.equalTo(self.locationLabel.snp.trailing).offset(10)
           }
           self.updatedTimeLabel.snp.makeConstraints {
               $0.height.equalTo(16)
               $0.centerY.equalTo(self.locationLabel.snp.centerY)
               $0.leading.equalTo(self.verticalSeperatedView.snp.trailing).offset(10)
           }
    }
    
    private func layoutsButtons() {
        self.buttonStackView.addArrangedSubViews(
            self.likeButton,
            self.shareButton
        )
        self.buttonStackView.addSubview(self.buttonSeperaterView)
        self.likeButton.snp.makeConstraints { $0.height.equalTo(40) }
        self.shareButton.snp.makeConstraints { $0.height.equalTo(40) }
        self.buttonSeperaterView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(1)
            $0.center.equalTo(self.buttonStackView)
        }
    }
}
