//
//  ProfileKeywordView2.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/10.
//

import Foundation
import UIKit

final class ProfileKeywordView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setEngFont(weight: .medium, size: 14)
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
    
    deinit {
        debugPrint("\(String(describing: self)) deinit")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true

    }
    
    private func setUpLayouts() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

