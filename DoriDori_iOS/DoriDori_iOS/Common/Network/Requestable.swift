//
//  Requestable.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/06/30.
//
import Foundation

protocol Requestable {
    typealias Parameter = [String: Any]
    var path: String { get }
    var parameters: Parameter? { get }
    var headers: HTTPHeaders? { get }
    var method: HTTPMethod { get }
}

extension Requestable {
    var method: HTTPMethod { .get }
}
