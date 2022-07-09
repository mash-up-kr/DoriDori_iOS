//
//  MyPageHeaderView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import Foundation
import UIKit

final class MyPageHeaderView: UICollectionReusableView {
    
    struct Item {
        let title: String
        let level: Int
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "매쉬업 방위대"
        return label
    }()
    
    private let levelView = LevelView(level: 1)
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow"), for: .normal)
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        return button
    }()
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"setting"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
    }
    
    func configure(_ item: MyPageHeaderView.Item) {
        self.titleLabel.text = item.title
        self.levelView.configure(level: item.level)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        self.addSubViews(views: self.titleLabel, self.levelView, self.moreButton, self.settingButton, self.shareButton)
        
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
            $0.width.equalTo(10)
            $0.height.equalTo(22)
            $0.trailing.equalTo(self.levelView.snp.trailing).offset(16)
        }
       
        self.settingButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(28)
            $0.top.equalToSuperview().offset(14)
        }
        
        self.shareButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(76)
            $0.top.equalToSuperview().offset(14)
        }
    }
}
