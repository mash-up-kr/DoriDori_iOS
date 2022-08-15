//
//  QuestionReceivedReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/15.
//

import Foundation
import ReactorKit

final class QuestionReceivedReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewDidLoad
    }
    enum Mutation {
        
    }
    
    struct State {
    }
    
    private let myPageRepository: MyPageRequestable
    
    init(
        myPageRepository: MyPageRequestable
    ) {
        self.myPageRepository = myPageRepository
        self.initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        return _state
    }
}
