//
//  QuestionReceivedReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/15.
//

import Foundation
import ReactorKit
import RxSwift
import RxRelay

final class QuestionReceivedReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewDidLoad
    }
    enum Mutation {
        case updateReceviedQuestion(questions: [MyPageOtherSpeechBubbleItemType])
    }
    
    struct State {
        var questions: [MyPageOtherSpeechBubbleItemType]
    }
    
    private let myPageRepository: MyPageRequestable
    
    init(
        myPageRepository: MyPageRequestable
    ) {
        self.myPageRepository = myPageRepository
        self.initialState = .init(questions: [])
    }
    
    private func fetchReceivedQuestion(size: Int) -> Observable<Mutation> {
        return self.myPageRepository.fetchReceivedQuestion(size: size)
            .flatMapLatest { [weak self] receivedQeustions -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let qeustionItems = receivedQeustions.compactMap(self.setupQuestionItem(_:))
                return .just(Self.Mutation.updateReceviedQuestion(questions: qeustionItems))
            }
    }
    
    private func setupQuestionItem(_ question: QuestionModel) -> MyPageOtherSpeechBubbleItemType? {
        guard let isAnonymous = question.anonymous else { return nil }
        guard let createdAt = DoriDoriDateFormatter(dateString: question.createdAt ?? "").createdAtText() else { return nil }
        if isAnonymous {
            return AnonymousMyPageSpeechBubbleCellItem(
                content: question.content ?? "",
                location: question.location ?? "",
                createdAt: createdAt,
                tags: [],
                userName: question.fromUser?.nickname ?? ""
            )
        } else {
            return IdentifiedMyPageSpeechBubbleCellItem(
                content: question.content ?? "",
                location: question.location ?? "",
                createdAt: createdAt,
                level: question.fromUser?.level ?? 0,
                imageURL: URL(string: question.fromUser?.profileImageURL ?? ""),
                tags: question.fromUser?.tags ?? [],
                userName: question.fromUser?.nickname ?? ""
            )
        }
    }
   
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchReceivedQuestion(size: 20)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .updateReceviedQuestion(let question):
            _state.questions = question
        }
        return _state
    }
}
