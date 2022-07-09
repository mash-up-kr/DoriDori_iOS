
//
//  ResponseModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/06/25.
//
import Foundation

struct ResponseModel<Model: Decodable>: Decodable {
    let success: Bool?
    let data: Model?
    let error: ErrorModel?
}
