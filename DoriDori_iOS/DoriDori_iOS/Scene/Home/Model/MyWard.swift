//
//  MyWard.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/10.
//

import Foundation

struct MyWard: Codable {
    let id, name, createdAt, remainDays: String
    let longitude: Double
    let latitude: Double
}
