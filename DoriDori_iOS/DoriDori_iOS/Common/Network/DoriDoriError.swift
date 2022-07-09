//
//  DoriDoriError.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/04.
//
import Foundation

enum DoriDoriError: Error {
    case fieldError
    case noData
    case noErrorModel

    var description: String {
        switch self {
        case .fieldError: return "reseponse model의 필드가 잘못되었습니다."
        case .noData: return "data 필드에 값이 없습니다"
        case .noErrorModel: return "success가 false이지만 errorModel이 없습니다."
        }
    }
}
