//
//  UIView+Extension.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit.UIView

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach(self.addSubview(_:))
    }
}
