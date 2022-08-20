//
//  MyPageRepository.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import Foundation
import RxSwift

protocol MyPageRequestable: AnyObject {
    func fetchMyProfile(userID: UserID) -> Observable<UserInfoModel>
    func fetchMyAnswerCompleteQuestions(lastQuestionID: QuestionID?, size: Int) -> Observable<[QuestionModel]>
    func fetchAnswerCompleteQuestions(userID: UserID, lastQuestionID: QuestionID?, size: Int) -> Observable<[QuestionModel]>
}

final class MyPageRepository: MyPageRequestable {
    func fetchMyProfile(userID: UserID) -> Observable<UserInfoModel> {
        Network().request(
            api: UserInfoRequest(userID: userID),
            responseModel: ResponseModel<UserInfoModel>.self
        )
    }

    func fetchMyAnswerCompleteQuestions(lastQuestionID: QuestionID?, size: Int) -> Observable<[QuestionModel]> {
        Network().request(
            api: MyAnswerCompleteRequest(lastQuestionID: QuestionID?, size: Int),
            responseModel: ResponseModel<[QuestionModel]>.self
        )
    }

    func fetchAnswerCompleteQuestions(userID: UserID, lastQuestionID: QuestionID?, size: Int) -> Observable<[QuestionModel]> {
        Network().request(
            api: AnswerCompleteRequest(userID: UserID, lastQuestionID: QuestionID?, size: Int),
            responseModel: ResponseModel<[QuestionModel]>.self
        )
    }
}
