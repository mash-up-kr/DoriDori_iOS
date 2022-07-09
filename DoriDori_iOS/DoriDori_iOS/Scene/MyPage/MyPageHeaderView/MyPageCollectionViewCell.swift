//
//  MyPageCollectionViewCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit

final class MyPageCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
