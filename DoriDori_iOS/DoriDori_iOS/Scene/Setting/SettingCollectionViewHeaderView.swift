//
//  SettingCollectionViewHeaderView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/14.
//

import UIKit

final class SettingCollectionViewHeaderView: UICollectionReusableView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .medium, size: 14)
        label.textColor = .gray400
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupLayouts() {
        self.addSubViews(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
    }
}
