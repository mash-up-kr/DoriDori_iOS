//
//  ProfileWardView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import UIKit

final class ProfileWardView: UIView {
    
    private let wardNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .regular, size: 12)
        return label
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.setUpLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(wardName: String) {
        self.wardNameLabel.text = wardName
    }
}

// MARK: - Private functions

extension ProfileWardView {
    private func configureUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    
    private func setUpLayouts() {
        self.addSubview(self.wardNameLabel)
        self.wardNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(1)
            $0.bottom.equalToSuperview().inset(1)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(18)
        }
    }
}
