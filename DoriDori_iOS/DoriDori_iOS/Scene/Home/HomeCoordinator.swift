//
//  HomeCoordinator.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/30.
//

import UIKit

protocol HomeCoordinatorPresentable: Coordinator {
    func navigateToQuestionDetail(postId: String)
}

final class HomeCoordinator: HomeCoordinatorPresentable {
    func start() {
        
    }
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToQuestionDetail(postId: String) {
//        WebViewCoordinator(
//            navigationController: self.navigationController,
//            type: .questionDetail(id: postId),
//            navigateStyle: .push
//        ).start()
    }
}
