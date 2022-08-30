//
//  MyWardRequest.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/17.
//

import Foundation

struct MyWardRequest: Requestable {
    var path: String { "/api/v1/ward" }
    var parameters: Parameter? { nil }
}
