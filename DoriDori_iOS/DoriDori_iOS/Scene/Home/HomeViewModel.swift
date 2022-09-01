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
    }
    
    enum Mutation {
        case setHomeCollectionViewReload(Bool)
        case setHomeModels(HomeSpeechs)
        case setHomeEmptyState(Bool)
        case setWardTitleLabel(String)
        case shouldShowLocationAlert
    }
    
    struct State {
        var homeSpeechModel: HomeSpeechs?
        var wardTitle: String = ""
        @Pulse var homeCollectionViewNeedReload: Bool = false
        @Pulse var locationViewNeedAnimate: Bool = false
        @Pulse var homeEmptyState: Bool = false
        @Pulse var shouldShowLocationAlert: Void? = nil
    }

    let initialState: State = State()
    let repository: HomeRepositoryRequestable
    var homeListNumberOfModel: Int { currentState.homeSpeechModel?.homeSpeech.count ?? 0 }
    private let locationManager: LocationManager
    init(
        repository: HomeRepositoryRequestable,
        locationManager: LocationManager
    ) {
        self.locationManager = locationManager
        self.repository = repository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reqeustHomeData:
            return requestHome()
        case let .like(id):
            return like(id: id)
        case let .dislike(id: id):
            return dislike(id: id)
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
        case let .shouldShowLocationAlert:
            newState.shouldShowLocationAlert = ()
        }
        
        return newState
    }
    
    private func requestHome() -> Observable<Mutation> {
       return self.locationManager
            .getLocation()
            .flatMapLatest { [weak self] result -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                switch result {
                case .success(let location):
                    UserDefaults.latitude = location.latitude
                    UserDefaults.longitude = location.longitude
                    
                    print("🤔UserDefaults.latitude", UserDefaults.latitude)
                    print("🤔UserDefaults.longitude", UserDefaults.longitude)
                    
                    return self.requestHomeData(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                    
                case .failure(let error):
                    print("🤔error")
                    return .just(.shouldShowLocationAlert)
                }
            }
    }
    
    private func requestHomeData(latitude: Double = UserDefaults.latitude, longitude: Double = UserDefaults.longitude) -> Observable<Mutation> {
        repository.requestHomeData(lastId: nil, latitude: latitude, longitude: longitude, meterDistance: 1000, size: 20)
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
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Mutation> in
                return owner.requestHomeData()
            }
    }
    
    private func dislike(id: String) -> Observable<Mutation> {
        repository.dislike(id: id)
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Mutation> in
                return owner.requestHomeData()
            }
    }
}
