//
//  MyPageTab.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/04.
//

import UIKit

enum MyPageTab: Equatable,
                CaseIterable {
    case answerComplete
    case questionReceived
    case seeAll
    
    var title: String {
        switch self {
        case .answerComplete: return "답변완료"
        case .questionReceived: return "받은질문"
        case .seeAll: return "모아보기"
        }
    }
    
//    var viewController: UIViewController.Type {
//        switch self {
//        case .answerComplete:
//            return AnswerCompleteViewController.self
//        case .questionReceived: return QuestionReceivedViewController.self
//        case .seeAll: return SeeAllViewController.self
//        }
//    }
}
