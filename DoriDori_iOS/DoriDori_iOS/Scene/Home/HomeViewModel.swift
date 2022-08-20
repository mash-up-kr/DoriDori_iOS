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
        case reqeustHomeData
        case locationCellDidTap(Bool)
    }
    
    enum Mutation {
        case setLocationCollectionViewReload(Bool)
        case setHomeCollectionViewReload(Bool)
        case setLocationModels([MyWard])
        case setHomeModels(HomeSpeechs)
    }
    
    struct State {
        var lactaionListModel: [MyWard] = []
        var homeSpeechModel: HomeSpeechs?
        @Pulse var locationCollectionViewNeedReload: Bool = false
        @Pulse var homeCollectionViewNeedReload: Bool = false
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
        case .reqeustHomeData:
            return requestHomeData()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLocationCollectionViewReload(locationCollectionViewNeedReload):
            newState.locationCollectionViewNeedReload = locationCollectionViewNeedReload
        case let .setHomeCollectionViewReload(homeCollectionViewNeedReload):
            newState.homeCollectionViewNeedReload = homeCollectionViewNeedReload
        case let .setLocationModels(models):
            newState.lactaionListModel = models
        case let .setHomeModels(models):
            newState.homeSpeechModel = models
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
    
    func requestHomeData() -> Observable<Mutation> {
        repository.requestHomeData(lastId: "62f26bb63af9661d5f868d25", latitude: 37.504030, longitude: 127.024099, meterDistance: 250, size: 20)
            .flatMap { models -> Observable<Mutation> in
                .concat([
                    .just(.setHomeModels(models)),
                    .just(.setHomeCollectionViewReload(true))
                ])
            }
    }
}
