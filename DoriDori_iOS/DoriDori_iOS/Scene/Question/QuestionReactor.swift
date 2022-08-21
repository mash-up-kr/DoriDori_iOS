//
//  QuestionReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import Foundation
import ReactorKit

final class QuestionReactor: Reactor {
    
    enum Constant {
        static let maxTextCount = 300
    }

    enum Action {
        case didEditing(text: String)
    }

    enum Mutation {
        case didEditing(text: String)
    }
    enum Reactor {
        
    }
    struct State {
        @Pulse var textCount: String
        @Pulse var canRegistQuestion: Bool
    }
    
    let initialState: State
    private let questionType: QuestionType
    
    init(questionType: QuestionType) {
        self.questionType = questionType
        self.initialState = .init(
            textCount: "0/\(Constant.maxTextCount)",
            canRegistQuestion: false
        )
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didEditing(let text):
            return .just(.didEditing(text: text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .didEditing(let text):
            if text.isEmpty { _state.canRegistQuestion = false }
            else { _state.canRegistQuestion = true }
            _state.textCount = self.setupTextCount(count: text.count)
        }
        return _state
    }
    
    private func setupTextCount(count: Int) -> String {
        return "\(count)/\(Self.Constant.maxTextCount)"
    }
}
