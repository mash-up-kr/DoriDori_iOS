//
//  OtherPageCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import Foundation
import UIKit

protocol OtherPageCoordinatable: Coordinator {
    func pop()
    func navigateToQuestionDetail(questionID: QuestionID, questionUserID: UserID)
    func navigateToOtherPage(userID: UserID)
    func navigateToProfileShare()
    func navigateToQuestion()
}

final class OtherPageCoordinator: OtherPageCoordinatable {
    let navigationController: UINavigationController
    private var userID: UserID
    
    init(
        navigationController: UINavigationController,
        userID: UserID
    ) {
        self.userID = userID
        self.navigationController = navigationController
    }
    
    func start() {
        let otherPageRepository = OtherPageRepository()
        let otherPageReactor = OtherPageReactor(repository: otherPageRepository, userID: self.userID)
        let contentReactor = OtherProfileContentReactor(repository: otherPageRepository, userID: self.userID)
        let contentViewController = OtherProfileContentViewController(
            reactor: contentReactor,
            coordinator: self
        )
        let otherPageViewController = OtherPageViewController(
            reactor: otherPageReactor,
            coordinator: self,
            contentViewController: contentViewController
        )
        self.navigationController.pushViewController(otherPageViewController, animated: true)
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
    
    func navigateToQuestionDetail(questionID: QuestionID, questionUserID: UserID) {
        WebViewCoordinator(
            navigationController: self.navigationController,
            type: .questionDetail(id: questionID, questionUserID: questionUserID),
            navigateStyle: .push
        ).start()
    }
    
    func navigateToProfileShare() {
        WebViewCoordinator(
            navigationController: self.navigationController,
            type: .share(id: self.userID),
            navigateStyle: .present
        ).start()
    }
    
    func navigateToQuestion() {
        QuestionCoordinator(
            navigationController: self.navigationController,
            questionType: .user(userID: self.userID)
        ).start()
    }
    func navigateToOtherPage(userID: UserID) {
        self.userID = userID
        self.start()
    }
}
