//
//  SignInViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/09.
//

import Foundation
import ReactorKit

enum SignInButtonType {
    case apple
    case kakao
    case email
    case emailSignup
}

final class SignInMainViewModel: Reactor {
    
    enum Action {
        case kakaoLoginButtonDidTap
        case appleLoginButtonDidTap
        case emailLoginButtonDidTap
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
        case .kakaoLoginButtonDidTap:
            return .just(.router(to: .kakao))
            
        case .appleLoginButtonDidTap:
            return .just(.router(to: .apple))
            
        case .emailLoginButtonDidTap:
            return .just(.router(to: .email))
            
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

