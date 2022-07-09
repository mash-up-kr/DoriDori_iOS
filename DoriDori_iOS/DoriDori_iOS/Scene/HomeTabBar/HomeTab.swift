//
//  HomeTab.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/25.
//

import Foundation
import UIKit

enum HomeTabType: CaseIterable {
    case notification
    case home
    case myPage
}

extension HomeTabType {
    var tabTitle: String? {
       return nil
    }
    
    var tabImage: UIImage? {
        switch self {
        case .notification:
            return UIImage(named: "NotificationTab")?.withTintColor(.gray700)
        case .home:
            return UIImage(named: "HomeTab")?.withTintColor(.gray700)
        case .myPage:
            return UIImage(named: "MyPageTab")?.withTintColor(.gray700)
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .notification:
            return UIImage(systemName: "NotificationTab")?.withTintColor(.lime300)
        case .home:
            return UIImage(systemName: "HomeTab")
        case .myPage:
            return UIImage(systemName: "MyPageTab")
        }
    }
}
