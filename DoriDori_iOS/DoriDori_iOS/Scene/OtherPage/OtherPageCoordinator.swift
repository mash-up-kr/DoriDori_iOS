//
//  OtherPageCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import Foundation
import UIKit

final class OtherPageCoordinator: Coordinator {
    var navigationController: UINavigationController
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
    
}
