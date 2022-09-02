//
//  DoriDoriWeb.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/27.
//

import Foundation

typealias PostID = String

enum DoriDoriWeb {
    case questionDetail(id: QuestionID)
    case postDetail(id: PostID)
    case profileSetting
    case share(id: UserID? = nil)
    case myLevel
    case alarmSetting
    case ward
    case notice
    case terms
    case openSource
    
    var path: String {
        switch self {
        case .questionDetail(let questionID): return "/question-detail?questionId=\(questionID)"
        case .postDetail(let postID): return "/post-detail?postId=\(postID)"
        case .profileSetting: return "/setting/my-profile"
        case .share(let userID):
            if let userID = userID {
                return "/open-inquiry?userId=\(userID)"
            } else {
                return "/open-inquiry"
            }
        case .myLevel: return "/my-level"
        case .alarmSetting: return "/setting/alarm"
        case .ward: return "/my-ward"
        case .notice: return "/setting/notice"
        case .terms: return "/setting/terms"
        case .openSource: return "/setting/open-source"
        }
    }
}
