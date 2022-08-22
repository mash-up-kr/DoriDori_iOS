//
//  DoriDoriLocationError.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/23.
//

import Foundation

enum DoriDoriLocationError: LocalizedError {
    case noData
    case unknownError
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .noData: return "위도,경도 정보가 없습니다"
        case .unknownError: return "위치를 불러오는데 알 수 없는 에러가 발생했습니다"
        case .timeout: return "위치를 불러오는데 시간이 초과되었습니다."
        }
    }
}
