//
//  HomeViewModel.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import Foundation
import ReactorKit

final class HomeViewModel: Reactor {
    
    enum Action {
        case locationCellDidTap(Bool)
    }
    
    enum Mutation {
        case setLocationCollectionViewReload(Bool)
    }
    
    struct State {
        // TODO: - Label 관련 모델로 변경해야됨
        @Pulse var lactaionListModel: [String] = []
        @Pulse var locationCollectionViewNeedReload: Bool = false
        @Pulse var locationViewNeedAnimate: Bool = false
    }

    let initialState: State
    let repository: HomeRepositoryRequestable

    init(repository: HomeRepositoryRequestable) {
        self.initialState = State()
        self.repository = repository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLocationCollectionViewReload(locationCollectionViewNeedReload):
            newState.locationCollectionViewNeedReload = locationCollectionViewNeedReload
        }
        return state
    }
}
