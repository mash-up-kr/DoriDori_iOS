//
//  AppDelegate.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/15.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // TODO: baseURL 을 변경해야합니다.
        let network = Network(baseURL: "fakeURL")
        return true
    }
}

