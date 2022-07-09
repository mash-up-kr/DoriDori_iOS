//
//  Rx+Extension.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/10.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIButton {
    var throttleTap: ControlEvent<Void> {
        let source = tap
            .throttle(
                .milliseconds(400),
                latest: false,
                scheduler: MainScheduler.instance
            )
        return ControlEvent(events: source)
    }
}
