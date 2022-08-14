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
}

extension Coordinator {
    var storyboard: UIStoryboard? {
        return nil
    }
}
