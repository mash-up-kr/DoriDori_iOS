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
        case like(id: String)
        case dislike(id: String)
        case comment(postId: String)
    }
    
    enum Mutation {
        case setLocationCollectionViewReload(Bool)
        case setHomeCollectionViewReload(Bool)
        case setLocationModels([MyWard])
        case setHomeModels(HomeSpeechs)
        case setHomeEmptyState(Bool)
    }
    
    struct State {
        var lactaionListModel: [MyWard] = []
        var homeSpeechModel: HomeSpeechs?
        @Pulse var locationCollectionViewNeedReload: Bool = false
        @Pulse var homeCollectionViewNeedReload: Bool = false
        @Pulse var locationViewNeedAnimate: Bool = false
        @Pulse var homeEmptyState: Bool = false
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
        case let .like(id):
            return like(id: id)
        case let .dislike(id: id):
            return dislike(id: id)
        case let .comment(postId: postId):
            return comment(postId: postId)
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
        case let .setHomeEmptyState(homeEmptyState):
            newState.homeEmptyState = homeEmptyState
        }
        
        return newState
    }
    
    private func requestHeaderViewData() -> Observable<Mutation> {
        repository.requestHomeHeaderData()
            .flatMap { models -> Observable<Mutation> in
                .concat([
                    .just(.setLocationModels(models)),
                    .just(.setLocationCollectionViewReload(true))
                ])
            }
    }
    
    private func requestHomeData() -> Observable<Mutation> {
        repository.requestHomeData(lastId: nil, latitude: 37.497175, longitude: 127.027926, meterDistance: 1000, size: 20)
            .flatMap { models -> Observable<Mutation> in
                if models.homeSpeech.isEmpty {
                    return .just(.setHomeEmptyState(true))
                }
                return .concat([
                    .just(.setHomeModels(models)),
                    .just(.setHomeEmptyState(false)),
                    .just(.setHomeCollectionViewReload(true))
                ])
            }
    }
    
    private func like(id: String) -> Observable<Mutation> {
        repository.like(id: id)
            .flatMap { _ -> Observable<Mutation> in
                    .just(.setHomeCollectionViewReload(true))
            }
    }
    
    private func dislike(id: String) -> Observable<Mutation> {
        repository.dislike(id: id)
            .flatMap { _ -> Observable<Mutation> in
                    .just(.setHomeCollectionViewReload(true))
            }
    }
    
    private func comment(postId: String) -> Observable<Mutation> {
        repository.comment(postId: postId)
            .flatMap { _ -> Observable<Mutation> in
                    .just(.setHomeCollectionViewReload(true))
            }
    }
}
