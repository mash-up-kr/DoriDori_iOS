//
//  MyPageTabCollectionViewCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/06.
//

import UIKit

final class MyPageTabCollectionViewCell: UICollectionViewCell {
    
    struct Item: Equatable {
        fileprivate let title: String
        fileprivate var isSelected: Bool
        
        init(title: String,
             isSelected: Bool) {
            self.title = title
            self.isSelected = isSelected
        }
        
        mutating func update(isSelected: Bool) {
            self.isSelected = isSelected
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = UIFont.setKRFont(weight: .medium, size: 16)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        self.contentView.addSubViews(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(_ item: Item) {
        self.titleLabel.text = item.title
        if item.isSelected {
            self.titleLabel.textColor = .white
        } else {
            self.titleLabel.textColor = .gray500
        }
    }
}
