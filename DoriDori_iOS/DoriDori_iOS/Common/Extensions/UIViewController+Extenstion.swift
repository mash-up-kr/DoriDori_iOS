//
//  UIViewController+Extenstion.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/08.
//

import Foundation
import UIKit

extension UIViewController {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
