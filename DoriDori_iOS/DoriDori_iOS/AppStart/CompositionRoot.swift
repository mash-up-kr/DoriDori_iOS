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
    case siginIn
}

struct CompositionRoot {
    static func resolve(window: UIWindow, appStart: AppStart) -> SceneDelegate.AppDependecy {
        
        let coordinator = AppCoordinator(appStart: appStart, window: window)
        coordinator.start()
        
        return SceneDelegate.AppDependecy(window: window)
    }
}
