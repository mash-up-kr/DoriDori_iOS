//
//  QuestionReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import Foundation
import ReactorKit

typealias Location = (longitude: Double, latitude: Double)

final class QuestionReactor: Reactor {
    
    enum Constant {
        static let maxTextCount = 300
    }

    enum Action {
        case didEditing(text: String)
        case didTapRegistQuestion
    }

    enum Mutation {
        case didEditing(text: String)
        case postQuestion
    }
    
    struct State {
        @Pulse var text: String
        @Pulse var textCount: String
        @Pulse var canRegistQuestion: Bool
        @Pulse var shouldPopViewController: Bool?
        @Pulse var location: Location?
        @Pulse var isAnonymous: Bool
    }
    
    let initialState: State
    private let questionType: QuestionType
    private let questionRepository: QuestionRequestable
    
    init(
        questionType: QuestionType,
        questionRepository: QuestionRequestable
    ) {
        self.questionRepository = questionRepository
        self.questionType = questionType
        self.initialState = .init(
            text: "",
            textCount: "0/\(Constant.maxTextCount)",
            canRegistQuestion: false,
            shouldPopViewController: nil,
            isAnonymous: false
        )
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didEditing(let text):
            return .just(.didEditing(text: text))
        case .didTapRegistQuestion:
            return self.postQuestion(questionType: self.questionType)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .didEditing(let text):
            if text.isEmpty { _state.canRegistQuestion = false }
            else { _state.canRegistQuestion = true }
            _state.textCount = self.setupTextCount(count: text.count)
            _state.text = text
        case .postQuestion:
            _state.shouldPopViewController = true
        }
        return _state
    }
    
    private func setupTextCount(count: Int) -> String {
        return "\(count)/\(Self.Constant.maxTextCount)"
    }
    
    private func postQuestion(questionType: QuestionType) -> Observable<Mutation> {
        let questionObservable: Observable<Void>
        switch questionType {
        case .user(let userID):
            questionObservable = self.questionRepository.postQuestion(
                userID: userID,
                content: self.currentState.text,
                longitude: 127.024099,
                latititude: 37.504030,
                anonymous: false
            )
            .map { _ in return }
        case .community:
            questionObservable = self.questionRepository.postQuestion(
                content: self.currentState.text,
                longitude: 127.024099,
                latitude: 37.504030,
                anonymous: self.currentState.isAnonymous
            )
            .map { _ in return }
        }
        return questionObservable
            .catch { error in
                print(error)
                return .empty()
            }
            .flatMapLatest { _ -> Observable<Mutation> in
                return .just(.postQuestion)
            }
    }
}
