//
//  Coordinator.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import UIKit

protocol Coordinator: AnyObject {
    var storyboard: UIStoryboard? { get }
    var navigationController: UINavigationController { get }
    func start()
    func popViewController(animated: Bool)
    func dismiss(animated: Bool, _ completion: (() -> Void)?)
}

extension Coordinator {
    var storyboard: UIStoryboard? {
        return nil
    }
    
    func popViewController(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool, _ completion: (() -> Void)?) {
        self.navigationController.dismiss(animated: animated, completion: completion)
    }
}
