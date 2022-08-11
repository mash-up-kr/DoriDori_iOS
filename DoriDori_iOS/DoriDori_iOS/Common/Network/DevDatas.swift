//
//  DevDatas.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import Foundation
import Alamofire

typealias HTTPHeaders = Alamofire.HTTPHeaders

let devUserID: String = "62d7f4776ad96c51d4330ea2"
extension Requestable {
    var headers: HTTPHeaders? {
        ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE3NTQyMzE0MTQsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.qYld9Je775prztT4oGWZ-4FDYg27TVJ24h1mQZG0fiE"]
    }
}
