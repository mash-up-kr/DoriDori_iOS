//
//  LevelView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit

final class LevelView: UIView {
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    
    // MARK: Init
    
    init(level: Int, backgroundColor: UIColor = .lime300) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setupLevel(level)
        self.configureUI()
        self.setUpLayouts()
    }
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.setUpLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(level: Int, backgroundColor: UIColor = .lime300) {
        self.setupLevel(level)
    }
}

// MARK: - Private

extension LevelView {
    
    private func configureUI() {
        self.backgroundColor = .lime300
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    private func setUpLayouts() {
        self.addSubview(self.levelLabel)
        self.levelLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().inset(3)
            $0.leading.equalToSuperview().offset(9.5)
            $0.trailing.equalToSuperview().inset(9.5)
        }
    }
    
    private func setupLevel(_ level: Int) {
        self.levelLabel.text = "Lv.\(level)"
    }
}
