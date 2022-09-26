//
//  DoriDoriQuestionPostDetailMore.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/26.
//

import Foundation

enum DoriDoriQuestionPostDetailMore {
    case modify
    case delete
    case toAnonymous
    case report
    case block
    
    var title: String {
        switch self {
        case .modify: return "수정하기"
        case .delete: return "삭제하기"
        case .toAnonymous: return "익명으로 변경"
        case .report: return "신고하기"
        case .block: return "글쓴이 차단하기"
        }
    }
    
    var action: ((String) -> Void) {
        switch self {
        case .modify:
           return { targetID in
                print(targetID, "수정하기")
            }
        default:
            return { targetID in
               print(targetID)
            }
        }
    }
}
