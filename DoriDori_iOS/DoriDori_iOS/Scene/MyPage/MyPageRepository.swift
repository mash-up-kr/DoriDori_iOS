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
    func fetchReceivedQuestions(size: Int, lastQuestionID: QuestionID?) -> Observable<ReceivedQuestionModel>
    func denyQuestion(questionID: QuestionID) -> Observable<String>
    func postComment(to questionID: QuestionID, content: String, location: Location) -> Observable<String>
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
    
    func fetchReceivedQuestions(size: Int, lastQuestionID: QuestionID?) -> Observable<ReceivedQuestionModel> {
        Network().request(
            api: ReceivedQuestionRequest(size: size, lastID: lastQuestionID),
            responseModel: ResponseModel<ReceivedQuestionModel>.self
        )
    }
    func denyQuestion(questionID: QuestionID) -> Observable<String> {
        Network().request(
            api: QuestionDenyRequest(questionID: questionID),
            responseModel: ResponseModel<String>.self
        )
    }
    func postComment(to questionID: QuestionID, content: String, location: Location) -> Observable<String> {
        Network().request(
            api: ReplyCommentRequest(
                questionID: questionID,
                content: content,
                location: location
            ),
            responseModel: ResponseModel<String>.self
        )
    }
}
