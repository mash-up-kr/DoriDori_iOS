//
//  MyWardListRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/22.
//

import Foundation

struct MyWardListRequest: Requestable {
    var path: String { "/api/v1/ward" }
    var parameters: Parameter? { nil }
}
