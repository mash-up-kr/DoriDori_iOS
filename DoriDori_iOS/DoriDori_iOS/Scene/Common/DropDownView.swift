//
//  DropDownView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import UIKit
import SnapKit

final class DropDownView: UIView {
    
    // MARK: - UIComponent
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .bold, size: 12)
        return label
    }()
    
    private let toggleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_down")
        return imageView
    }()

    // MARK: - Init
    
    init(
        title: String
    ) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.setupView()
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shouldChangeToggleImage(isDropDowned: Bool) {
        var image: UIImage?
        if isDropDowned { image = UIImage(named: "arrow_up") }
        else { image = UIImage(named: "arrow_down")}
        self.toggleImageView.image = image
    }
    
    func update(title: String) {
        self.titleLabel.text = title
    }
}

// MARK: - Private functions

extension DropDownView {
    
    private func setupView() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray700.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func setupLayouts() {
        self.addSubViews(self.titleLabel, self.toggleImageView)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
        self.toggleImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.titleLabel)
            $0.leading.equalTo(self.titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(6)
        }
    }
}
