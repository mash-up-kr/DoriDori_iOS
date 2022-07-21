//
//  TermsOfServiceViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/21.
//

import Foundation
import ReactorKit

final class TermsOfServiceViewModel: Reactor {
    
    enum Action {
        
    }
    enum Mutation {
        
    }
    struct State {
        
    }

    let initialState: State

    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        return state
    }
}
