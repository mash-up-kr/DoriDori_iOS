//
//  DoriDoriEmptyView.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/28.
//

import UIKit

final class DoriDoriEmptyView: UIView {
    
    private let emptyImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "emptyImageView")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.setKRFont(weight: .bold, size: 12)
        label.text = "질문할 사람을 찾고 있어요!"
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(emptyImageView)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        emptyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(emptyImageView)
        }
    }
}
