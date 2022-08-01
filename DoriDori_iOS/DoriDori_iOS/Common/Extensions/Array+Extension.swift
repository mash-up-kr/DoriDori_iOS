//
//  Array+Extension.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/01.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
