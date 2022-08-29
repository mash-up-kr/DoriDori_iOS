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
        case reqeustHomeData
        case like(id: String)
        case dislike(id: String)
        case comment(postId: String)
    }
    
    enum Mutation {
        case setHomeCollectionViewReload(Bool)
        case setHomeModels(HomeSpeechs)
        case setHomeEmptyState(Bool)
        case setWardTitleLabel(String)
    }
    
    struct State {
        var homeSpeechModel: HomeSpeechs?
        var wardTitle: String = ""
        @Pulse var homeCollectionViewNeedReload: Bool = false
        @Pulse var locationViewNeedAnimate: Bool = false
        @Pulse var homeEmptyState: Bool = false
    }

    let initialState: State = State()
    let repository: HomeRepositoryRequestable
    var homeListNumberOfModel: Int { currentState.homeSpeechModel?.homeSpeech.count ?? 0 }
    
    init(repository: HomeRepositoryRequestable) {
        self.repository = repository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
        case let .setHomeCollectionViewReload(homeCollectionViewNeedReload):
            newState.homeCollectionViewNeedReload = homeCollectionViewNeedReload
        case let .setHomeModels(models):
            newState.homeSpeechModel = models
        case let .setHomeEmptyState(homeEmptyState):
            newState.homeEmptyState = homeEmptyState
        case let .setWardTitleLabel(title):
            newState.wardTitle = title
        }
        
        return newState
    }
    
    private func requestHomeData() -> Observable<Mutation> {
        repository.requestHomeData(lastId: nil, latitude: 37.497175, longitude: 127.027926, meterDistance: 1000, size: 20)
            .flatMap { models -> Observable<Mutation> in
                if models.homeSpeech.isEmpty {
                    return .just(.setHomeEmptyState(true))
                }
                let wardTitle = models.homeSpeech.first?.representativeAddress ?? ""
                return .concat([
                    .just(.setHomeModels(models)),
                    .just(.setHomeEmptyState(false)),
                    .just(.setWardTitleLabel(wardTitle)),
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
