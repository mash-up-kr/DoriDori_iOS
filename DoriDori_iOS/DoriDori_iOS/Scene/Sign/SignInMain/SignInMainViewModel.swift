//
//  SignInViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/09.
//

import Foundation
import ReactorKit

enum SignInButtonType {
    case emailSignIn
    case emailSignup
}

final class SignInMainViewModel: Reactor {
    
    enum Action {
        case emailSignInButtonDidTap
        case emailSignupButtonDidTap
    }
    
    enum Mutation {
        case router(to: SignInButtonType)
    }
    
    struct State {
        @Pulse var buttonType: SignInButtonType?
        
    }

    let initialState: State

    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .emailSignInButtonDidTap:
            return .just(.router(to: .emailSignIn))
            
        case .emailSignupButtonDidTap:
            return .just(.router(to: .emailSignup))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .router(to: let type):
            newState.buttonType = type
        }
        
        return newState
    }
}

