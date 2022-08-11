//
//  UIPageViewController+Rx.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/10.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

//extension Reactive where Base: UIPageViewController {
//    var dataSource: DelegateProxy<UIPageViewController, UIPageViewControllerDataSource> {
//        RxPageViewControllerDataSourceProxy.proxy(for: base)
//    }
//
//    func after<DataSource: RxPageViewControllerDataSourceProxy & UIPageViewControllerDataSource, Source: ObservableType>(dataSource: DataSource) -> (_ source: Source) -> Disposable where DataSource.Element == Source.Element {
//        return { source in
//            _ = self.delegate
//
//            return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource, retainDataSource: true) { [weak pageViewController = self.base], (_: RxPageViewControllerDataSourceProxy, event) -> Void in
//                guard let pageViewController = pageViewController else { return }
//                dataSource.pageViewController(<#T##pageViewController: UIPageViewController##UIPageViewController#>, viewControllerAfter: <#T##UIViewController#>)
//            }
//        }
//    }
//}

final class RxPageViewControllerDataSourceProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDataSource>, DelegateProxyType {
    
    typealias Element = UIViewController
    
    static func registerKnownImplementations() {
        self.register {
            RxPageViewControllerDataSourceProxy(pageViewController: $0)
        }
    }
    
    static func currentDelegate(for object: UIPageViewController) -> UIPageViewControllerDataSource? {
        return object.dataSource
    }
    
    static func setCurrentDelegate(_ delegate: UIPageViewControllerDataSource?, to object: UIPageViewController) {
        object.dataSource = delegate
    }
    
    weak private(set) var pageViewController: UIPageViewController?
    
    init(pageViewController: ParentObject) {
        self.pageViewController = pageViewController
        super.init(parentObject: pageViewController, delegateProxy: RxPageViewControllerDataSourceProxy.self)
    }
}
