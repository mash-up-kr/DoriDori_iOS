//
//  HomeTab.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/25.
//

import Foundation
import UIKit

enum HomeTabType: CaseIterable {
    case first
    case second
    case third
}

extension HomeTabType {
    var tabTitle: String {
        switch self {
        case .first:
            return "first"
        case .second:
            return "Second"
        case .third:
            return "Third"
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .first:
            return UIImage(systemName: "book")
        case .second:
            return UIImage(systemName: "book")
        case .third:
            return UIImage(systemName: "book")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .first:
            return UIImage(systemName: "pencil")
        case .second:
            return UIImage(systemName: "pencil")
        case .third:
            return UIImage(systemName: "pencil")
        }
    }
}
