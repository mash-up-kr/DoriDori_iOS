//
//  OtherProfileContentReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/25.
//

import Foundation
import RxRelay
import RxSwift
import ReactorKit

final class OtherProfileContentReactor: Reactor {
    enum Action {
        case viewDidLoad
    }
    enum Mutation {
    }
    struct State {
        @Pulse var questionAndAnswer: [MyPageBubbleItemType] = []
    }
    
    var initialState: State
    private let repository: OtherPageRequestable
    private let userID: UserID
    
    init(
        repository: OtherPageRequestable,
        userID: UserID
    ) {
        self.userID = userID
        self.repository = repository
        self.initialState = .init()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        return .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            self.repository.fetchQuestionAndAnswer(size: 20, userID: self.userID)
                .catch { error in
                    print(error)
                    return .empty()
                }
//                .map { response in
//                    let quetsions = response.questions ?? []
//                    quetsions.compactMap { question -> MyPageBubbleItemType? in
//                        guard let isAnonymousQuestion = question.anonymous else { return nil }
//                        let otherSpeechBubbleItem: MyPageOtherSpeechBubbleItemType
//                        if isAnonymousQuestion {
//                            otherSpeechBubbleItem = AnonymousMyPageSpeechBubbleCellItem(
//                                content: question.content ?? "",
//                                location: question.representativeAddress ?? "",
//                                updatedTime: 1,
//                                tags: question.fromUser?.tags ?? [],
//                                userName: question.fromUser?.nickname ?? ""
//                            )
//                        } else {
//                            otherSpeechBubbleItem = IdentifiedMyPageSpeechBubbleCellItem(
//                                content: question.content ?? "",
//                                location: question.representativeAddress ?? "",
//                                updatedTime: 1,
//                                level: question.fromUser?.level ?? 1,
//                                imageURL: question.fromUser?.profileImageURL,
//                                tags: question.fromUser?.tags ?? [],
//                                userName: question.fromUser?.nickname ?? ""
//                            )
//                        }
//
//                        let mySpeechBubbleItem = MyPageMySpeechBubbleCellItem(userName: question.answer?.user?.nickname ?? "", content: question.answer?.content ?? "", location: question.answer., updatedTime: <#T##Int#>, likeCount: <#T##Int#>, profileImageURL: <#T##URL?#>, level: <#T##Int#>)
//                    }
//                }
        }
        return .empty()
    }
}
