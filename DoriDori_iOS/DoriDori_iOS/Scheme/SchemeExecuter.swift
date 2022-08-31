//
//  SchemeExecuter.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/20.
//

import UIKit

struct SchemeExecuter {
    private let schemeType: SchemeType
    
    init(schemeType: SchemeType) {
        self.schemeType = schemeType
        prepareSchemeExecuter()
    }
    
    func execute() {
        
        guard let navigation = UIViewController.topViewController()?.navigationController as? UINavigationController else {
            fatalError("can not find navigaion controller")
        }
        
        switch schemeType {
        case let .question(userId):
            print("userId: \(userId)")
            QuestionCoordinator(
                navigationController: navigation,
                questionType: .user(userID: userId)
            ).start()
        case .mypage_other(let userID):
            print("userId", userID)
            OtherPageCoordinator(
                navigationController: navigation,
                userID: userID
            ).start()
        }
    }
    
    private func prepareSchemeExecuter() {
        guard
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let presentedViewController = sceneDelegate.window?.rootViewController?.presentedViewController else {
                return
            }
        
        presentedViewController.dismissOrPopupViewController(animated: true, completion: nil)
    }
}
