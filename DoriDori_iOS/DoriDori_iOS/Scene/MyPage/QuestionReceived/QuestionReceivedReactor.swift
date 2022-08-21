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
        case commentRegist(text: String)
        case didTapDeny(questionID: String)
    }
    enum Mutation {
        case updateLoadingIndicator(isLoading: Bool)
        case updateReceviedQuestion(questions: [MyPageOtherSpeechBubbleItemType])
        case toast(text: String)
    }
    
    struct State {
        @Pulse var updateLoading: Bool = false
        @Pulse var toast: String?
        @Pulse var questions: [MyPageOtherSpeechBubbleItemType]
    }
    
    private let myPageRepository: MyPageRequestable
    
    init(
        myPageRepository: MyPageRequestable
    ) {
        self.myPageRepository = myPageRepository
        self.initialState = .init(questions: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchReceivedQuestion(size: 20)
        case .commentRegist(let text):
            if text.isEmpty { return .just(.toast(text: "1글자 이상 적어주세요!")) }
            else { return .just(.updateReceviedQuestion(questions: [])) }
        case .didTapDeny(let questionID):
            return self.denyQuestion(questionID: questionID)
        }
    }


    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .updateLoadingIndicator(let update):
            _state.updateLoading = update
        case .updateReceviedQuestion(let questions):
            _state.questions = questions
        case .toast(let text):
            _state.toast = text
        }
        return _state
    }
}

// MARK: - Private functions

extension QuestionReceivedReactor {
    
    private func fetchReceivedQuestion(size: Int) -> Observable<Mutation> {
        return self.myPageRepository.fetchReceivedQuestion(size: size)
            .flatMapLatest { [weak self] receivedQeustions -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let qeustionItems = receivedQeustions.compactMap(self.setupQuestionItem(_:))
                return .concat(
                    .just(Self.Mutation.updateLoadingIndicator(isLoading: true)),
                    .just(Self.Mutation.updateReceviedQuestion(questions: qeustionItems)),
                    .just(Self.Mutation.updateLoadingIndicator(isLoading: false))
                )
            }
    }
    
    private func denyQuestion(questionID: String) -> Observable<Mutation> {
        return self.myPageRepository.denyQuestion(questionID: questionID)
            .catch { error in
                print(error)
                return .empty()
            }
            .flatMap { [weak self] _ -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                var _questions = self.currentState.questions
                let index: Int? = self.currentState.questions.firstIndex { question in
                    return question.questionID == questionID
                }
                guard let index = index else { return .empty() }
                _questions.remove(at: index)
                return .concat(
                    .just(.updateLoadingIndicator(isLoading: true)),
                    .just(.updateReceviedQuestion(questions: _questions)),
                    .just(.updateLoadingIndicator(isLoading: false))
                )
            }
    }
    
    private func setupQuestionItem(_ question: QuestionModel) -> MyPageOtherSpeechBubbleItemType? {
        guard let isAnonymous = question.anonymous else { return nil }
        guard let createdAt = DoriDoriDateFormatter(dateString: question.createdAt ?? "").createdAtText(),
              let questionID = question.id else { return nil }
        if isAnonymous {
            return AnonymousMyPageSpeechBubbleCellItem(
                questionID: questionID,
                content: question.content ?? "",
                location: question.location ?? "",
                createdAt: createdAt,
                tags: [],
                userName: question.fromUser?.nickname ?? ""
            )
        } else {
            return IdentifiedMyPageSpeechBubbleCellItem(
                questionID: questionID,
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
   
}
