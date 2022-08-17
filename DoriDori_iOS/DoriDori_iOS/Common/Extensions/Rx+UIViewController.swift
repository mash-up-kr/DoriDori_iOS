//
//  Rx+UIViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/17.
//

import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in () }
    }
    
    var viewDidLoad: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in () }
    }
}
