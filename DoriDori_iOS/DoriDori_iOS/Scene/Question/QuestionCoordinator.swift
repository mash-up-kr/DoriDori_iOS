//
//  QuestionCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import UIKit

enum QuestionType {
    case user
    case community
}

final class QuestionCoordinator: Coordinator {
    
    private let questionType: QuestionType
    let navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController,
        questionType: QuestionType
    ) {
        self.questionType = questionType
        self.navigationController = navigationController
    }
    
    func start() {
        let qeustionReactor = QuestionReactor(questionType: self.questionType)
        let questionViewController = QuestionViewController(reactor: qeustionReactor)
        navigationController.pushViewController(questionViewController, animated: true)
    }
}
