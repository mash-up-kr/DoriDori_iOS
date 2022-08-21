//
//  DoriDoriToastView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/20.
//

import UIKit
import RxSwift
import SnapKit

final class DoriDoriToastView: UIView {
    
    private let dismissTime: Int
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .regular, size: 13)
        return label
    }()
    
    init(
        text: String,
        dismissTime: Int = 4
    ) {
        self.dismissTime = dismissTime
        super.init(frame: .zero)
        self.setupViews()
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor(red: 37, green: 37, blue: 37, alpha: 0.8)
    }
    
    func show() {
        
    }
}
