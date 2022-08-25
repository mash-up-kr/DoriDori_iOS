//
//  SceneDelegate.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/15.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    struct AppDependecy {
        let window: UIWindow
    }
    
    var window: UIWindow?
    private var dependency: AppDependecy!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        guard let newWindow = self.window else { return }
        
        self.dependency = CompositionRoot.resolve(window: newWindow, appStart: .siginIn)
        self.window = dependency.window
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        Scheme.open(data: url)
    }
}

