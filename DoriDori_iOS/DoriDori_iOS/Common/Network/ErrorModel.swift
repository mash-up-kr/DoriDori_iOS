
//
//  ErrorModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/06/30.
//
import Foundation

struct ErrorModel: Decodable, Error {
    let code: String?
    let meesage: String?
}
