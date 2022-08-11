//
//  Array+Extension.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/05.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if indices ~= index {
            return self[index]
        } else { return nil }
    }
}
