//
//  QuestionCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import UIKit

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
        let questionRepository = QuestionRepository()
        let locationManager = DoriDoriLocationManager()
        let qeustionReactor = QuestionReactor(
            questionType: self.questionType,
            questionRepository: questionRepository,
            locationManager: locationManager
        )
        let questionViewController = QuestionViewController(
            reactor: qeustionReactor,
            coordinator: self
        )
        navigationController.pushViewController(questionViewController, animated: true)
    }
}
