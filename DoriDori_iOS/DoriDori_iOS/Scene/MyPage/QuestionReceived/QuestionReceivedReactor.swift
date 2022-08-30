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
        case didTapProfile(IndexPath)
        case didTapDeny(IndexPath)
        case didTapComment(IndexPath)
    }
    
    enum Mutation {
        case questions([MyPageOtherSpeechBubbleItemType])
        case didTapProfile(UserID)
    }
    
    struct State {
        @Pulse var receivedQuestions: [MyPageOtherSpeechBubbleItemType] = []
        @Pulse var navigateQuestionID: QuestionID?
        @Pulse var navigateUserID: UserID?
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
                .flatMapLatest { response -> Observable<Mutation> in
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
        case .didTapProfile(let indexPath):
            guard let question = self.currentState.receivedQuestions[safe: indexPath.item] else { return .empty() }
            return .just(.didTapProfile(question.userID))
        case .didTapDeny(let indexPath):
            print("didTApDeny")
        case .didTapComment(let indexPath):
            print("didTapcomment")
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .questions(let questions):
            _state.receivedQuestions = questions
        case .didTapProfile(let userID):
            _state.navigateUserID = userID
        }
        return _state
    }
}
