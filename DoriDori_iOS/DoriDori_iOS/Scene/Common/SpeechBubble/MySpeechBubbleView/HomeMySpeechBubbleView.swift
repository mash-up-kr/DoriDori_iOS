//
//  HomeMySpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import UIKit
import RxSwift


protocol HomeSpeechBubleViewDelegate: AnyObject {
    func likeButtonDidTap(id: String, userLiked: Bool)
    func commentButtonDidTap(postId: String)
    func shareButtonDidTap()
}

final class HomeMySpeechBubbleView: MySpeechBubbleView,
                                    SpeechBubbleViewLikeable,
                                    SpeechBubbleViewTaggable,
                                    SpeechBubbleViewCommentable {
    
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
    
    // MARK: - Properties
    var likeButtonType: LikeButtonType { .hand }
    weak var delegate: HomeSpeechBubleViewDelegate?
    private let disposeBag = DisposeBag()
    private var homeSpeechInfo: HomeSpeechInfo?
    
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
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeMySpeechBubbleView {
    
    func configure(_ item: HomeSpeechInfo) {
        homeSpeechInfo = item
        self.locationLabel.text = item.representativeAddress
        self.userNameLabel.text = item.user.nickname
        self.setupContentLabel(item.content, at: self.contentLabel)
        self.setupLikeButton(item.likeCount, at: self.handButton)
        self.setupCommentButton(item.commentCount, at: self.commentButton)
        self.setupTagStackView(item.user.tags)
        
        guard let updatedTimeText = DoriDoriDateFormatter(dateString: item.updatedAt).createdAtText() else {
            return
        }
        self.updatedTimeLabel.text = updatedTimeText
    }
    
    private func setupTagStackView(_ tags: [String]) {
        tagStackView.arrangedSubviews.forEach { view in
            NSLayoutConstraint.deactivate(self.constraints.filter({ $0.firstItem === view || $0.secondItem === view }))
            view.removeFromSuperview()
        }
        let tagViews = self.configureTagViews(tags)
        self.tagStackView.isHidden = tagViews.isEmpty
        tagViews.forEach(self.tagStackView.addArrangedSubview(_:))
    }
    
    private func bind() {
        handButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let info = owner.homeSpeechInfo else { return }
                owner.delegate?.likeButtonDidTap(id: info.id, userLiked: info.userLiked)
            })
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let info = owner.homeSpeechInfo else { return }
                owner.delegate?.commentButtonDidTap(postId: info.id)
            })
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.delegate?.shareButtonDidTap()
            })
            .disposed(by: disposeBag)
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
