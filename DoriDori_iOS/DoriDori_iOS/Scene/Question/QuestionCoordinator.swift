//
//  QuestionCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import UIKit

final class QuestionCoordinator: Coordinator {
    let navigationController: UINavigationController
    func start() {
        let questionViewController = QuestionViewController(nibName: nil, bundle: nil)
        navigationController.pushViewController(questionViewController, animated: true)
    }
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
}
