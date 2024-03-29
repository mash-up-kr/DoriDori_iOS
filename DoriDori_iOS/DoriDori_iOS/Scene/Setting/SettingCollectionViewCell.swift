//
//  SettingCollectionViewCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/13.
//

import UIKit

final class SettingCollectionViewCell: UICollectionViewCell {

    // MARK: - UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .medium, size: 14)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lime300
        label.font = UIFont.setKRFont(weight: .bold, size: 14)
        return label
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
        self.subTitleLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(title: String, subTitle: String?) {
        self.titleLabel.text = title
        if let subTitle = subTitle {
            self.subTitleLabel.isHidden = false
            self.subTitleLabel.text = subTitle
        }
    }
}

// MARK: - Private functions

extension SettingCollectionViewCell {
    
    private func setupLayouts() {
        self.contentView.addSubViews(self.titleLabel, self.subTitleLabel, self.underLineView)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        self.underLineView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        self.subTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    }
}
