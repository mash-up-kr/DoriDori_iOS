//
//  OtherQuestionCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/10.
//

import UIKit

final class OtherQuestionCell: UICollectionViewCell {
    
    // MARK: - UIComponent
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultProfileImage")
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray800.cgColor
        imageView.backgroundColor = .gray900
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let levelView: LevelView = .init(level: 3, backgroundColor: .lime400)
    
    private let speechBubbleView: MyPageSpeechBubble = {
        let view = MyPageSpeechBubble(
            borderWidth: 1,
            borderColor: .gray500,
            backgroundColor: .gray900
        )
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray200
        label.text = "감자도리도리"
        label.font = UIFont.setKRFont(weight: .medium, size: 13)
        return label
    }()
    
    private let keywordStackView: UIStackView = {
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
        label.text = "#도리 를 찾아서가 뭐에요?"
        label.font = UIFont.setKRFont(weight: .medium, size: 16)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray600
        label.text = "강남구"
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray700
        return view
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .gray600
        label.text = "1분 전"
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setKeywordStackView()
        self.setupLayouts()
        self.setInfoStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    
    private func setupLayouts() {
        self.addSubViews(views: self.profileImageView, self.levelView, self.speechBubbleView)
//        self.speechBubbleView.addSubViews(views: self.userNameLabel, self.keywordStackView, self.contentLabel, self.infoStackView, self.moreButton)
        
        self.profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(42)
        }
        
        self.levelView.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(self.profileImageView.snp.centerX)
        }
        
        self.speechBubbleView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        /*
        self.userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(26)
        }
        
        self.keywordStackView.snp.makeConstraints {
            $0.top.equalTo(self.userNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
        }
        
        self.moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(15)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.keywordStackView.snp.bottom).offset(16)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        self.infoStackView.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(16)
            $0.leading.equalTo(self.userNameLabel.snp.leading)
        }
        self.dividerView.snp.makeConstraints {
            $0.width.equalTo(1)
        }
         */
    }
    
    let dummyKeywordTitle: [String] = ["디즈니", "영화", "애니메이션"]
    
    private func setKeywordStackView() {
        (0..<3).forEach { index in
            let keywordView = KeywordView()
            keywordView.configure(title: dummyKeywordTitle[index])
            self.keywordStackView.addArrangedSubview(keywordView)
        }
    }
    
    private func setInfoStackView() {
        [self.locationLabel, self.dividerView, self.createdAtLabel].forEach {
            self.infoStackView.addArrangedSubview($0)
        }
    }
    
}
