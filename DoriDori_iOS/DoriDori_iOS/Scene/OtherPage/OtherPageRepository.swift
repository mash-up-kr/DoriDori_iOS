//
//  OtherPageRepository.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import Foundation
import RxSwift

protocol OtherPageRequestable: AnyObject {
    func fetchOtherProfile(userID: UserID) -> Observable<UserInfoModel>
    func fetchQuestionAndAnswer(size: Int, userID: UserID) -> Observable<AnswerCompleteModel>
    func requestReport(type: ReportType, targetID: String) -> Observable<Bool>
}

final class OtherPageRepository: OtherPageRequestable {
    func fetchOtherProfile(userID: UserID) -> Observable<UserInfoModel> {
        Network().request(
            api: UserInfoRequest(userID: userID),
            responseModel: ResponseModel<UserInfoModel>.self
        )
    }
    
    func fetchQuestionAndAnswer(size: Int, userID: UserID) -> Observable<AnswerCompleteModel> {
        Network().request(
            api: AnswerCompleteRequest(
                userID: userID,
                lastQuestionID: nil,
                size: size
            ),
            responseModel: ResponseModel<AnswerCompleteModel>.self
        )
    }
    
    func requestReport(type: ReportType, targetID: String) -> Observable<Bool> {
        Network().request(
            api: ReportRequest(type: type, targetID: targetID),
            responseModel: ResponseModel<Bool>.self
        )
    }
}
