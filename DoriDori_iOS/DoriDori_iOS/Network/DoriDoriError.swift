//
//  DoriDoriError.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/04.
//

import Foundation

enum DoriDoriError: Error {
    case field_error
    case no_data
    case no_errorModel
    
    
    var description: String {
        switch self {
        case .field_error: return "reseponse model의 필드가 잘못되었습니다."
        case .no_data: return "data 필드에 값이 없습니다"
        case .no_errorModel: return "success가 false이지만 errorModel이 없습니다."
        }
    }
}
