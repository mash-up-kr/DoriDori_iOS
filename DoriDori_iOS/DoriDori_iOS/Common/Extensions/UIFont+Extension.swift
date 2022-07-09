//
//  UIFont+Extension.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit

extension UIFont {
    static let SFPro: String = "SF-Pro"
    static let SpoqaHanSansNeo: String = "SpoqaHanSansNeo"
    
    static func setKRFont(weight: UIFont.Weight, size: CGFloat) -> UIFont? {
        return UIFont(name: "\(UIFont.SpoqaHanSansNeo)-\(weight.name)", size: size)
    }
    
    static func setEngFont(weight: UIFont.Weight, size: CGFloat) -> UIFont? {
        return UIFont(name: "\(UIFont.SFPro)-Display-\(weight.name)", size: size)
    }
}

extension UIFont.Weight {
    var name: String {
        switch self {
        case .medium: return "Medium"
        case .light: return "Light"
        case .regular: return "Regular"
        case .bold: return "Bold"
        default: return ""
        }
    }
}
