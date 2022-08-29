//
//  MyPageRepository.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import Foundation
import RxSwift

protocol MyPageRequestable: AnyObject {
    func fetchMyProfile() -> Observable<UserInfoModel>
    func fetchMyAnswerCompleteQuestions(lastQuestionID: QuestionID?, size: Int) -> Observable<AnswerCompleteModel>
    func fetchAnswerCompleteQuestions(userID: UserID, lastQuestionID: QuestionID?, size: Int) -> Observable<[QuestionModel]>
}

final class MyPageRepository: MyPageRequestable {
    func fetchMyProfile() -> Observable<UserInfoModel> {
        Network().request(
            api: MyProfileRequest(),
            responseModel: ResponseModel<UserInfoModel>.self
        )
    }

    func fetchMyAnswerCompleteQuestions(lastQuestionID: QuestionID?, size: Int) -> Observable<AnswerCompleteModel> {
        Network().request(
            api: MyAnswerCompleteRequest(lastQuestionID: lastQuestionID, size: size),
            responseModel: ResponseModel<AnswerCompleteModel>.self
        )
    }

    func fetchAnswerCompleteQuestions(userID: UserID, lastQuestionID: QuestionID?, size: Int) -> Observable<[QuestionModel]> {
        Network().request(
            api: AnswerCompleteRequest(userID: userID, lastQuestionID: lastQuestionID, size: size),
            responseModel: ResponseModel<[QuestionModel]>.self
        )
    }
}
