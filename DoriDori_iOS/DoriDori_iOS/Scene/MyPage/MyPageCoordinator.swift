//
//  MyPageCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit

protocol MyPageCoordinatable: Coordinator {
    func navigateToSetting()
    func navigateToShare()
    func navigateToQuestionDetail(questionID: QuestionID)
    func navigateToOtherPage(userID: UserID)
}

final class MyPageCoordinator: MyPageCoordinatable {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit { debugPrint(" \(self) deinit") }
    
    func start() {
        let myPageViewModel = MyPageReactor(
            myPageTabs: [MyPageTab.answerComplete, .questionReceived],
            initialSeletedTab: .answerComplete,
            myPageRepository: MyPageRepository()
        )
        let mypageViewController = MyPageViewController(myPageCoordinator: self, reactor: myPageViewModel)
        navigationController.pushViewController(mypageViewController, animated: true)
    }
    
    func navigateToSetting() {
        SettingCoordinator(navigationController: self.navigationController).start()
    }
    
    func navigateToShare() {
        WebViewCoordinator(
            navigationController: self.navigationController,
            type: .share(),
            navigateStyle: .present
        ).start()
    }
    
    func navigateToQuestionDetail(questionID: QuestionID) {
        WebViewCoordinator(
            navigationController: self.navigationController,
            type: .questionDetail(id: questionID),
            navigateStyle: .push
        ).start()
    }
    
    func navigateToOtherPage(userID: UserID) {
        OtherPageCoordinator(
            navigationController: self.navigationController,
            userID: userID
        ).start()
    }
}
