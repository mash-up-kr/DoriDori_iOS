//
//  UIViewController+Extenstion.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/08.
//

import Foundation
import UIKit

extension UIViewController {
    
    func configureSignUpNavigationBar() {
        navigationItem.title = "입장하기"
        navigationController?.navigationBar.topItem?.title = ""
    }
}
