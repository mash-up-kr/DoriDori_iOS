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
}

final class SignInViewModel: Reactor {
    typealias Mutation = Action
    enum Action {
        case tapSignInButton(SignInButtonType)
    }
    
    struct State {
        var provider: SignInButtonType?
    }

    let initialState: State

    init() {
        self.initialState = State()
    }

//    func mutate(action: Action) -> Observable<Mutation> {
//        print("mutation", action)
//        return .just(action)
//    }

    func reduce(state: State, action: Mutation) -> State {
        print("reduce state", state)
        var _state = state
        switch action {
        case .tapSignInButton(let type):
            _state.provider = type
            print(state.provider)
        }
        return _state
    }
}
