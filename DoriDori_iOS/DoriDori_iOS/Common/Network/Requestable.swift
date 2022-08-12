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
extension Requestable {
    var headers: HTTPHeaders? {
        ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE3NTQyMzE0MTQsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.qYld9Je775prztT4oGWZ-4FDYg27TVJ24h1mQZG0fiE"]
    }
}
