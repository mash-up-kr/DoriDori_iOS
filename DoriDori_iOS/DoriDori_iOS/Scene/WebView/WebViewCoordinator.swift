//
//  WebViewCoordinator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/27.
//

import UIKit

enum WebViewNavigateStyle {
    case push
    case present
}

protocol WebViewCoordinatable: Coordinator {
    func close()
}

final class WebViewCoordinator: WebViewCoordinatable {

    
    private let type: DoriDoriWeb
    private let navigateStyle: WebViewNavigateStyle
    
    let navigationController: UINavigationController
    init(
        navigationController: UINavigationController,
        type: DoriDoriWeb,
        navigateStyle: WebViewNavigateStyle
    ) {
        self.navigationController = navigationController
        self.type = type
        self.navigateStyle = navigateStyle
    }
    
    func start() {
        switch self.navigateStyle {
        case .push:
            self.startPushTypeWebViewController()
        case .present:
            self.startPresentTypeWebViewController()
        }
    }
    
    private func startPushTypeWebViewController() {
        
    }
    
    private func startPresentTypeWebViewController() {
        let viewController = ModalTypeWebViewController(type: self.type, coordinator: self)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController.present(navigationController, animated: true)
    }
    
    func close() {
        self.navigationController.topViewController?.dismiss(animated: true)
    }
    
}
