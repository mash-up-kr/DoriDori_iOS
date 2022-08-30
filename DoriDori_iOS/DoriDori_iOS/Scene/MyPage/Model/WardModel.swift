//
//  WardModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/29.
//

import Foundation

struct WradModel: Codable {
    var wardID: WardID?
    var name: String?
    var longitude: Double?
    var latitude: Double?
    var city: String?
    var isRepresentative: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name, longitude, latitude, city, isRepresentative
        case wardID = "id"
    }
}
