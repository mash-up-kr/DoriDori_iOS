//
//  MyWardDropDownItem.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/22.
//

import Foundation

struct MyWardDropDownItem: Equatable,
                           DropDownItemType {
    let name: String
    let longitude: Double?
    let latitude: Double?
    var isSelected: Bool
    
}
