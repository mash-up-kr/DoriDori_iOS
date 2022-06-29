//
//  Requestable.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/06/30.
//

import Foundation

protocol Requestable {
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: HTTPMethod { get }
}
