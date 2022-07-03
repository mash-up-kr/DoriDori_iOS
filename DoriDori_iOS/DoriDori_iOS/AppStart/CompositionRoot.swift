//
//  CompositionRoot.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/02.
//

import UIKit

enum AppStart {
    // TODO: - SignIn, Splash등 추가 예정
    case home
}

struct CompositionRoot {
    static func resolve(window: UIWindow, start: AppStart) -> SceneDelegate.AppDependecy {
        
        switch start {
            case .home:
                window.rootViewController = HomeTabBarController()
        }
        
        return SceneDelegate.AppDependecy(window: window)
    }
}
