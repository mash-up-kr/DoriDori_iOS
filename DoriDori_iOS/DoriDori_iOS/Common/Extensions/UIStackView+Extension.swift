//
//  UIStackView+Extension.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/23.
//

import UIKit

extension UIStackView {
    /// arranged subview를 추가하기때문에 파라미터 순서를 잘 지켜 add해야합니다.
    func addArrangedSubViews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
