//
//  Int+Extension.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/25.
//

import Foundation

extension Int {
    var decimalString: String? {
        let numberFomatter = NumberFormatter()
        numberFomatter.numberStyle = .decimal
        return numberFomatter.string(for: self)
    }
}
