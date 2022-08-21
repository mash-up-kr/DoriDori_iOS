
//
//  ErrorModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/06/30.
//
import Foundation

struct ErrorModel: Codable, Error {
    let code: String?
    let message: String?
}
