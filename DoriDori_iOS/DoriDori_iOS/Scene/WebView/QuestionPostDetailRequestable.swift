//
//  QuestionPostDetailRequestable.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/26.
//

import Foundation
import RxSwift

protocol QuestionPostDetailRequestable: AnyObject {
    func deleteQuestion(questionID: QuestionID) -> Observable<String>
    func deletePost(postID: PostID) -> Observable<Bool>
    func blockUser(userID: UserID) -> Observable<Bool>
}

final class QuestionPostDetailRepository: QuestionPostDetailRequestable {
    func deleteQuestion(questionID: QuestionID) -> Observable<String> {
        Network().request(api: DeleteQuestionRequest(questionID: questionID), responseModel: ResponseModel<String>.self)
    }
    func deletePost(postID: PostID) -> Observable<Bool> {
        Network().request(api: DeletePostRequest(postID: postID), responseModel: ResponseModel<Bool>.self)
    }
    
    func blockUser(userID: UserID) -> Observable<Bool> {
        Network().request(api: BlockUserRequest(userID: userID), responseModel: ResponseModel<Bool>.self)
    }
}
