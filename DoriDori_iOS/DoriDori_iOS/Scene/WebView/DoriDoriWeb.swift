//
//  DoriDoriWeb.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/27.
//

import Foundation

enum DoriDoriWeb {
    case questionDetail(id: QuestionID)
    case profileSetting
    case share
    case myLevel
    case alarmSetting
    case ward
    case notice
    case terms
    case openSource
    
    var path: String {
        switch self {
        case .questionDetail(let id): return "/question-detail?questionId=\(id)"
        case .profileSetting: return "/setting/my-profile"
        case .share: return "/open-inquiry"
        case .myLevel: return "/my-level"
        case .alarmSetting: return "/setting/alarm"
        case .ward: return "/my-ward"
        case .notice: return "/my-ward"
        case .terms: return "/my-ward"
        case .openSource: return "/my-ward"
        }
    }
}
