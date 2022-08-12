//
//  MyPageHeaderView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import Foundation
import UIKit
import Kingfisher

struct MyPageProfileItem: Equatable {
    let nickname: String
    let level: Int
    let profileImageURL: String?
    let description: String
    let tags: [String]
}

final class MyPageProfileView: UIView {
    
    // MARK: - UIComponent
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .setKRFont(weight: .medium, size: 24)
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
    
    // Profile
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 26
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray700.cgColor
        imageView.layer.borderWidth = 1
        imageView.isHidden = true
        return imageView
    }()
    
    private let keywordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let introduceLabel: UILabel = {
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

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray900
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Configure
    
    func configure(_ item: MyPageProfileItem) {
        self.titleLabel.text = item.nickname
        self.levelView.configure(level: item.level)
        self.introduceLabel.text = item.description
        self.setupKeywordStackView(tags: item.tags)
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
    
    // MARK: Setup Layouts
    
    private func setupKeywordStackView(tags: [String]) {
        tags.forEach { tag in
            let keywordView = KeywordView()
            keywordView.configure(title: tag)
            self.keywordStackView.addArrangedSubview(keywordView)
        }
    }
   
    
    private func setupLayouts() {
        [self.settingButton, self.shareButton].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        [self.keywordStackView, self.introduceLabel].forEach {
            self.profileStackView.addArrangedSubview($0)
        }
        
        self.addSubViews(self.titleLabel, self.levelView, self.moreButton, self.buttonStackView, self.profileImageView, self.profileStackView)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(30)
        }
        
        self.levelView.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel.snp.centerY)
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
        }
        
        self.moreButton.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel.snp.centerY)
            $0.leading.equalTo(self.levelView.snp.trailing).offset(8)
            $0.width.equalTo(10)
            $0.height.equalTo(22)
        }
       
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        self.profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(52)
        }
        
        self.profileStackView.snp.makeConstraints {
            $0.centerY.equalTo(self.profileImageView.snp.centerY)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
        }
    }
}
