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
        switch schemeType {
        case let .question(userId):
            print("id: \(userId)")
        case .mypage_other:
            print("MYPAGE_OTHER")
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
