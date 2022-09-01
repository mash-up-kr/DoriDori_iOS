//
//  EmptyCell.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/02.
//

import Foundation
import UIKit
import SnapKit

final class EmptyCell: UICollectionViewCell {
    let emptyView: DoriDoriEmptyView = .init()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.emptyView.configure(title: title)
    }
}
