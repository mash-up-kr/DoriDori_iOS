//
//  KeywordView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/10.
//

import UIKit

final class KeywordView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray400
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.setUpLayouts()
    }
    
    convenience init(title: String) {
        self.init()
        self.titleLabel.text = title
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
        self.backgroundColor = .gray800
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    private func setUpLayouts() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(1)
            $0.bottom.equalToSuperview().inset(1)
            $0.leading.equalToSuperview().offset(6)
            $0.trailing.equalToSuperview().inset(6)
        }
    }
}
