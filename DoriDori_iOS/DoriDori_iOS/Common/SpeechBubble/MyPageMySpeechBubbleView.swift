//
//  MyPageMySpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/31.
//

import UIKit

protocol MyPageMySpeechBubbleViewItemType {
    var questioner: String { get }
    var userName: String { get }
    var content: String { get }
    var location: String { get }
    var updatedTime: Int { get }
    var likeCount: Int { get }
}

final class MyPageMySpeechBubbleView: MySpeechBubbleView {
    
    // MARK: - UIComponent
    
    private let questionerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .medium, size: 13)
        label.textColor = UIColor.gray200
        label.text = "매쉬업방위대"
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
        label.text = "감자도리도리"
        return label
    }()
    private let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
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
        label.font = UIFont.setKRFont(weight: .medium, size: 16)
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.text = "#니모 의 절친 물고기입니다"
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray600
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        label.text = "강남구"
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
        label.text = "1 분ㅈ너"
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
        button.setImage(UIImage(named: "hand_off"), for: .normal)
        return button
    }()
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
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Init
    
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
    
    func configure(_ item: MyPageMySpeechBubbleViewItemType) {
        self.questionerNameLabel.text = item.questioner
        self.userNameLabel.text = item.userName
        self.setupContent(item.content)
        self.locationLabel.text = item.location
        self.updatedTimeLabel.text = "\(item.updatedTime)분 전"
        self.setupHandButton(item.likeCount)
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
        self.layoutIfNeeded()
    }
    private func setupContent(_ content: String) {
        let textParagraphStype = NSMutableParagraphStyle()
        textParagraphStype.maximumLineHeight = 25
        textParagraphStype.minimumLineHeight = 25
        self.contentLabel.attributedText = NSMutableAttributedString(string: content, attributes: [
            .font: UIFont.setKRFont(weight: .medium, size: 16),
            .paragraphStyle: textParagraphStype,
            .foregroundColor: UIColor.white
        ])
    }
    private func setupLayouts() {
       
        self.layoutsUserInfo()
        self.layoutsLocationAndTime()
        self.layoutsButton()
      
        self.addSubViews(
            self.userInfoStackView,
            self.moreButton,
            self.contentLabel,
            self.locationTimeStackView,
            self.horizontalSeperatedView,
            self.buttonStackView
        )
        
        self.userInfoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(16)
        }
        self.moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(24)
        }
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.userInfoStackView.snp.bottom).offset(18)
            $0.leading.equalTo(self.userInfoStackView.snp.leading)
            $0.trailing.equalToSuperview().inset(28)
        }
        self.locationTimeStackView.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(18)
            $0.leading.equalTo(self.contentLabel.snp.leading)
        }
        self.horizontalSeperatedView.snp.makeConstraints {
            $0.top.equalTo(self.locationTimeStackView.snp.bottom).offset(16)
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(self.contentLabel)
        }
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalTo(self.horizontalSeperatedView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layoutsUserInfo() {
        self.userInfoStackView.addArrangedSubViews(
            self.questionerNameLabel,
            self.bracketImageView,
            self.userNameLabel
        )
        self.questionerNameLabel.snp.makeConstraints { $0.height.equalTo(18) }
        self.bracketImageView.snp.makeConstraints {
            $0.width.equalTo(4)
            $0.height.equalTo(8)
        }
        self.userNameLabel.snp.makeConstraints { $0.height.equalTo(18) }
    }
    
    private func layoutsLocationAndTime() {
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
    }
    
    private func layoutsButton() {
        self.buttonStackView.addArrangedSubViews(
            self.handButton,
            self.buttonSeperaterView,
            self.shareButton
        )
        self.handButton.snp.makeConstraints { $0.height.equalTo(40) }
        self.buttonSeperaterView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(1)
        }
        self.shareButton.snp.makeConstraints { $0.height.equalTo(40) }
    }
}
