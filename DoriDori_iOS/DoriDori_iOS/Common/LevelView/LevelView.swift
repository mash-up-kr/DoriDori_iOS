//
//  LevelView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit

final class LevelView: UIView {
    let levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    init(level: Int) {
        super.init(frame: .zero)
        self.configureUI()
        self.levelLabel.text = "Lv.\(level)"
        self.setUpLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}
