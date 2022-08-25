//
//  MyPageProfileView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit
import Kingfisher
import RxRelay
import RxSwift
import RxCocoa

struct MyPageProfileItem: Equatable {
    let nickname: String
    let level: Int
    let profileImageURL: String?
    let description: String
    let tags: [String]
//    let didTapSettingButton: PublishRelay<Void>
    
    static func == (lhs: MyPageProfileItem, rhs: MyPageProfileItem) -> Bool {
        (lhs.level == rhs.level) &&
        (lhs.nickname == rhs.nickname) &&
        (lhs.description == rhs.description) &&
        (lhs.tags == rhs.tags) &&
        (lhs.profileImageURL == rhs.profileImageURL)
    }
}

final class MyPageProfileView: UIView {
    
    // MARK: - UIComponent
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .setKRFont(weight: .bold, size: 24)
        return label
    }()
    
    private let levelView: LevelView = {
       let levelView = LevelView()
        levelView.isHidden = true
        return levelView
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.isHidden = true
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.isHidden = true
        return button
    }()
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"setting"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 24
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 26
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray700.cgColor
        imageView.layer.borderWidth = 1
        imageView.isHidden = true
        return imageView
    }()
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .medium, size: 13)
        return label
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray900
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure
    
    func configure(_ item: MyPageProfileItem) {
        self.nicknameLabel.text = item.nickname
        self.levelView.configure(level: item.level)
        self.descriptionLabel.text = item.description
        self.setupTagViews(tags: item.tags)
        if self.levelView.isHidden { self.levelView.isHidden = false }
        if self.moreButton.isHidden { self.moreButton.isHidden = false }
        if self.profileImageView.isHidden { self.profileImageView.isHidden = false }
        if self.settingButton.isHidden { self.settingButton.isHidden = false }
        if self.shareButton.isHidden { self.shareButton.isHidden = false }
        if let profileImageURL = item.profileImageURL {
            self.profileImageView.kf.setImage(with: URL(string: profileImageURL))
        } else {
            self.profileImageView.image = UIImage(named: "defaultProfileImage")
        }
    }
    
    func bindAction(didTapSettingButton: PublishRelay<Void>, didTapShareButton: PublishRelay<Void>) {
        self.settingButton.rx.throttleTap
            .bind(to: didTapSettingButton)
            .disposed(by: self.disposeBag)
        
        self.shareButton.rx.throttleTap
            .bind(to: didTapShareButton)
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Privates

extension MyPageProfileView {

    private func setupTagViews(tags: [String]) {
        tags.forEach { tag in
            let keywordView = KeywordView()
            keywordView.configure(title: tag)
            self.tagStackView.addArrangedSubview(keywordView)
        }
    }
   
    
    private func setupLayouts() {
        [self.shareButton, self.settingButton].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        [self.tagStackView, self.descriptionLabel].forEach {
            self.profileStackView.addArrangedSubview($0)
        }
        
        self.addSubViews(self.nicknameLabel, self.levelView, self.moreButton, self.buttonStackView, self.profileImageView, self.profileStackView)
        
        self.nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(30)
        }
        
        self.levelView.snp.makeConstraints {
            $0.centerY.equalTo(self.nicknameLabel.snp.centerY)
            $0.leading.equalTo(self.nicknameLabel.snp.trailing).offset(8)
        }
        
        self.moreButton.snp.makeConstraints {
            $0.centerY.equalTo(self.nicknameLabel.snp.centerY)
            $0.leading.equalTo(self.levelView.snp.trailing).offset(8)
            $0.width.equalTo(10)
            $0.height.equalTo(22)
        }
       
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        self.profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.nicknameLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(52)
        }
        
        self.profileStackView.snp.makeConstraints {
            $0.centerY.equalTo(self.profileImageView.snp.centerY)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
        }
    }
}
