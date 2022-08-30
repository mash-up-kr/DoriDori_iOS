//
//  QuestionReceivedReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/30.
//

import Foundation
import ReactorKit

final class QuestionReceivedReactor: Reactor {
    enum Action {
        case viewDidLoad
    }
    enum Mutation {
        case questions([MyPageOtherSpeechBubbleItemType])
    }
    struct State {
        @Pulse var receivedQuestions: [MyPageOtherSpeechBubbleItemType] = []
    }
    var initialState: State
    
    private var lastQuestionID: QuestionID?
    private let myPageRepository: MyPageRequestable
    init(
        myPageRepository: MyPageRequestable
    ) {
        self.myPageRepository = myPageRepository
        self.initialState = .init()
    }
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.myPageRepository.fetchReceivedQuestions(size: 20, lastQuestionID: self.lastQuestionID)
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { [weak self] response -> Observable<Mutation> in
                    guard let questions = response.questions else { return .just(.questions([])) }
                    let questionItems = questions.compactMap { question -> MyPageOtherSpeechBubbleItemType? in
                        guard let isAnonymousQuestion = question.anonymous else { return nil }
                        if isAnonymousQuestion {
                            return AnonymousMyPageSpeechBubbleCellItem(
                                userID: question.fromUser?.id ?? "",
                                questionID: question.id ?? "",
                                content: question.content ?? "",
                                location: question.representativeAddress ?? "",
                                updatedTime: 1,
                                tags: question.fromUser?.tags ?? [],
                                userName: question.fromUser?.nickname ?? ""
                            )
                        } else {
                            return IdentifiedMyPageSpeechBubbleCellItem(
                                userID: question.fromUser?.id ?? "",
                                questionID: question.id ?? "",
                                content: question.content ?? "",
                                location: question.representativeAddress ?? "",
                                updatedTime: 1,
                                level: question.fromUser?.level ?? 1,
                                imageURL: URL(string: question.fromUser?.profileImageURL ?? ""),
                                tags: question.fromUser?.tags ?? [],
                                userName: question.fromUser?.nickname ?? ""
                            )
                        }
                    }
                    return .just(.questions(questionItems))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .questions(let questions):
            _state.receivedQuestions = questions
        }
        return _state
    }
}
