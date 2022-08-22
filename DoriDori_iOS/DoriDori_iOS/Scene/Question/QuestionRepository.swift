//
//  QuestionRepository.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import Foundation
import RxSwift

protocol QuestionRequestable: AnyObject {
    func postQuestion(userID: UserID, content: String, longitude: Double, latitude: Double, anonymous: Bool) -> Observable<EmptyModel>
    func postQuestion(content: String, longitude: Double, latitude: Double, anonymous: Bool) -> Observable<EmptyModel>
    func fetchMyWardList() -> Observable<[MyWardModel]>
}

final class QuestionRepository: QuestionRequestable {
    func postQuestion(userID: UserID, content: String, longitude: Double, latitude: Double, anonymous: Bool) -> Observable<EmptyModel> {
        Network().request(
            api: QuestionToUserRequest(
                userID: userID,
                content: content,
                longtitude: longitude,
                latitude: latitude,
                anonymous: anonymous
            ),
            responseModel: ResponseModel<EmptyModel>.self
        )
    }
    
    func postQuestion(content: String, longitude: Double, latitude: Double, anonymous: Bool) -> Observable<EmptyModel> {
        Network().request(
            api:
                QuestionAtCommunityRequest(
                    content: content,
                    longtitude: longitude,
                    latitude: latitude,
                    anonymous: anonymous
                ),
            responseModel: ResponseModel<EmptyModel>.self
        )
    }
    
    func fetchMyWardList() -> Observable<[MyWardModel]> {
        Network().request(
            api: MyWardListRequest(),
            responseModel: ResponseModel<[MyWardModel]>.self
        )
    }
}
