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
        
//        UserDefaults.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE3NTQyMzE0MTQsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.qYld9Je775prztT4oGWZ-4FDYg27TVJ24h1mQZG0fiE"
//        UserDefaults.refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE2NzYyMTY2NDYsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.SjS4nCB9AfiRG3v8cbYUdUIXsrJSbePZM-mIyjOBsiA"

    }
    
 
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        Scheme.open(data: url)
    }
}

