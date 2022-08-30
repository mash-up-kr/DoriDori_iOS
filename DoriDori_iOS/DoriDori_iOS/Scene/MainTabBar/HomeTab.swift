//
//  HomeTab.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/25.
//

import Foundation
import UIKit

enum HomeTabType: CaseIterable {
    case home
    case myPage
}

extension HomeTabType {
    var tabTitle: String? {
       return nil
    }
    
    var tabImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home")?.withTintColor(.gray700)
        case .myPage:
            return UIImage(named: "MyPageTab")?.withTintColor(.gray700)
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "home")
        case .myPage:
            return UIImage(systemName: "MyPageTab")
        }
    }
}
