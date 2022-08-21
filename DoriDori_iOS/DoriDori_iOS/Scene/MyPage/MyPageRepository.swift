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
    func fetchReceivedQuestion(size: Int) -> Observable<[QuestionModel]>
    func denyQuestion(questionID: String) -> Observable<Void>
}

final class MyPageRepository: MyPageRequestable {
    func fetchMyProfile(userID: UserID) -> Observable<UserInfoModel> {
        Network().request(
            api: UserInfoRequest(userID: userID),
            responseModel: ResponseModel<UserInfoModel>.self
        )
    }
    func fetchReceivedQuestion(size: Int) -> Observable<[QuestionModel]> {
        Network().request(
            api: ReceivedQuestionRequest(size: size),
            responseModel: ResponseModel<ReceivedQuestionModel>.self
        ).map(\.questions)
    }
    func denyQuestion(questionID: String) -> Observable<Void> {
        return Network().request(
            api: QuestionDenyRequest(questionID: questionID),
            responseModel: ResponseModel<EmptyModel>.self
        ).map { _ in return }
    }
}

struct EmptyModel: Codable {
}
