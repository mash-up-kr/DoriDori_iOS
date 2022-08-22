//
//  MyWardListModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/22.
//

import Foundation

typealias WardID = String

struct MyWardModel: Codable {
    var id: WardID?
    var name: String?
    var longitude: Double?
    var latitude: Double?
}
