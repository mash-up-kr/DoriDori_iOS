//
//  AnonymousDropDownItem.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/22.
//

import Foundation

protocol DropDownItemType {
    var isSelected: Bool { get set }
    mutating func update(isSelected: Bool)
}
extension DropDownItemType {
    mutating func update(isSelected: Bool) {
        self.isSelected = isSelected
    }
}


enum AnonymousDropDownItemType: CaseIterable {
    case nickanme
    case anonymous
    
    var name: String {
        switch self {
        case .anonymous: return "익명"
        case .nickanme: return "닉네임"
        }
    }
}

struct AnonymousDropDownItem: Equatable,
                              DropDownItemType {
    let type: AnonymousDropDownItemType
    var name: String { type.name }
    var isSelected: Bool
}
