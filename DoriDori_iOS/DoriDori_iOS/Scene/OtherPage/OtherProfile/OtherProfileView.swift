//
//  OtherProfileView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import UIKit
import RxSwift
import RxCocoa

struct OtherProfileItem: Equatable {
    let nickname: String
    let level: Int
    let profileImageURL: String?
    let description: String
    let tags: [String]
    let representativeWard: String? // TODO: 어떻게 내려주는지 낼 아침에 물어봐야지~
}

final class OtherProfileView: UIView {
    
    // MARK: - UIComponent
    
    private let navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        return button
    }()
    
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
    
    private let wardView: ProfileWardView = {
        let view = ProfileWardView()
        view.isHidden = true
        return view
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.isHidden = true
        return button
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
    
    private let questionButton: UIButton = {
        let button = UIButton()
        button.setTitle("질문하기", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray700.cgColor
        button.layer.cornerRadius = 8
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 12)
        return button
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
    
    func configure(_ item: OtherProfileItem) {
        self.nicknameLabel.text = item.nickname
        self.levelView.configure(level: item.level)
        self.descriptionLabel.text = item.description
        if let wardName = item.representativeWard {
            self.wardView.configure(wardName: wardName)
        }
        self.setupTagViews(tags: item.tags)
        if self.wardView.isHidden { self.wardView.isHidden = false }
        if self.levelView.isHidden { self.levelView.isHidden = false }
        if self.profileImageView.isHidden { self.profileImageView.isHidden = false }
        if self.shareButton.isHidden { self.shareButton.isHidden = false }
        if let profileImageURL = item.profileImageURL {
            self.profileImageView.kf.setImage(with: URL(string: profileImageURL))
        } else {
            self.profileImageView.image = UIImage(named: "defaultProfileImage")
        }
    }
    
    func bindAction(didTapShareButton: PublishRelay<Void>) {
        
        self.shareButton.rx.throttleTap
            .bind(to: didTapShareButton)
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Privates

extension OtherProfileView {
    private func setupTagViews(tags: [String]) {
        tags.forEach { tag in
            let keywordView = KeywordView()
            keywordView.configure(title: tag)
            self.tagStackView.addArrangedSubview(keywordView)
        }
    }
    
    private func setupLayouts() {
        [self.tagStackView, self.descriptionLabel].forEach {
            self.profileStackView.addArrangedSubview($0)
        }
        
        self.addSubViews(self.navigationBackButton, self.nicknameLabel, self.levelView, self.wardView, self.shareButton, self.profileImageView, self.profileStackView, self.questionButton)
        self.navigationBackButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(23)
        }
        self.nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(self.navigationBackButton.snp.trailing).offset(4)
        }
        
        self.levelView.snp.makeConstraints {
            $0.centerY.equalTo(self.nicknameLabel.snp.centerY)
            $0.leading.equalTo(self.nicknameLabel.snp.trailing).offset(8)
        }

        self.wardView.snp.makeConstraints {
            $0.centerY.equalTo(self.nicknameLabel.snp.centerY)
            $0.leading.equalTo(self.levelView.snp.trailing).offset(8)
        }
        
        self.shareButton.snp.makeConstraints {
            $0.centerY.equalTo(self.nicknameLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(30)
            $0.size.equalTo(24)
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
        self.questionButton.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(34)
        }
    }
}
