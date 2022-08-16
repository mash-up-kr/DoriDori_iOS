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
        case requestHeaderViewData
        case locationCellDidTap(Bool)
    }
    
    enum Mutation {
        case setLocationCollectionViewReload(Bool)
        case setLocationModels([MyWard])
    }
    
    struct State {
        var lactaionListModel: [MyWard] = []
        var homeSpeechModel: [HomeSpeech] = []
        @Pulse var locationCollectionViewNeedReload: Bool = false
        @Pulse var locationViewNeedAnimate: Bool = false
    }

    let initialState: State = State()
    let repository: HomeRepositoryRequestable
    var locationListNumberOfModel: Int { currentState.lactaionListModel.count }
    
    init(repository: HomeRepositoryRequestable) {
        self.repository = repository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case.requestHeaderViewData:
            return requestHeaderViewData()
        case .locationCellDidTap(_):
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLocationCollectionViewReload(locationCollectionViewNeedReload):
            newState.locationCollectionViewNeedReload = locationCollectionViewNeedReload
        case let .setLocationModels(models):
            newState.lactaionListModel = models
        }
        return newState
    }
    
    func requestHeaderViewData() -> Observable<Mutation> {
        repository.requestHomeHeaderData()
            .flatMap { models -> Observable<Mutation> in
                .concat([
                    .just(.setLocationModels(models)),
                    .just(.setLocationCollectionViewReload(true))
                ])
            }
    }
}
