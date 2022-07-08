//
//  Coordinator.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/08.
//

import Foundation

protocol Coordinator: AnyObject {
    var storyboard: UIStoryboard? { get }
    func start()
}

extension Coordinator {
    var storyboard: UIStoryboard? {
        return nil
    }
}
