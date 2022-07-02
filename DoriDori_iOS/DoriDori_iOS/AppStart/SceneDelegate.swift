//
//  SceneDelegate.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    struct AppDependecy {
        let window: UIWindow
    }
    
    var window: UIWindow?
    private var dependency: AppDependecy!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.dependency = CompositionRoot.resolve(window: self.window!, start: .home)
        self.window = dependency.window
        self.window?.makeKeyAndVisible()
    }
}

