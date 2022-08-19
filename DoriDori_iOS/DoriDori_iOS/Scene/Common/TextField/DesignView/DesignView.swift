//
//  DesignView.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/30.
//

import Foundation

import UIKit

open class DesignView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed("UnderLineTextField", owner: self, options: nil)?.first as! UIView
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.frame = self.bounds
        self.addSubview(view)
        
        loaded()
    }
    
    open func loaded() {
        
    }
}
