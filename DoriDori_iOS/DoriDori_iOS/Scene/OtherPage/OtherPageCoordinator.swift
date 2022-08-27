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
    func navigateToQuestionDetail(questionID: QuestionID)
    func navigateToProfileShare()
    func navigateToQuestion()
}

final class OtherPageCoordinator: OtherPageCoordinatable {
    let navigationController: UINavigationController
    private let userID: UserID
    
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
        let otherPageViewController = OtherPageViewController(reactor: otherPageReactor, coordinator: self)
        self.navigationController.pushViewController(otherPageViewController, animated: true)
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
    
    func navigateToQuestionDetail(questionID: QuestionID) {
        WebViewCoordinator(
            navigationController: self.navigationController,
            type: .questionDetail(id: questionID),
            navigateStyle: .push
        ).start()
    }
    
    func navigateToProfileShare() {
        WebViewCoordinator(
            navigationController: self.navigationController,
            type: .share,
            navigateStyle: .push
        ).start()
    }
    
    func navigateToQuestion() {
        QuestionCoordinator(
            navigationController: self.navigationController,
            questionType: .user(userID: self.userID)
        ).start()
    }
}