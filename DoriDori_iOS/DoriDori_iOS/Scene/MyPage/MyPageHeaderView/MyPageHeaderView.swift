//
//  MyPageHeaderView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import Foundation
import UIKit

final class MyPageHeaderView: UICollectionReusableView {
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
//        self.addSubViews(views: self.titleLabel, self.levelView, )
    }
}
