//
//  DoriDoriError.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/04.
//
import Foundation

enum DoriDoriError: String, Error {
    case fieldError
    case noData
    case noErrorModel
    case TOKEN_EXPIRED

    var description: String {
        switch self {
        case .fieldError: return "reseponse model의 필드가 잘못되었습니다."
        case .noData: return "data 필드에 값이 없습니다"
        case .noErrorModel: return "success가 false이지만 errorModel이 없습니다."
        case .TOKEN_EXPIRED: return "토큰이 만료되었습니다"
        }
    }
}
