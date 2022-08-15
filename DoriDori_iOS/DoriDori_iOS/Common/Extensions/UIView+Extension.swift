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
    
    @IBInspectable var ibCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    @IBInspectable var ibBorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var ibBorderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
