//
//  DoriDoriActivityIndicator.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/20.
//

import UIKit

final class DoriDoriActivityIndicator: UIActivityIndicatorView {
    typealias Style =  UIActivityIndicatorView.Style
    
    init(
        style: Style = .large,
        color: UIColor = .lime300
    ) {
        super.init(style: style)
        self.style = style
        self.color = color
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
