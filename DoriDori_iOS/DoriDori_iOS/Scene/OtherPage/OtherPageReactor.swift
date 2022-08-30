//
//  OtherPageReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import ReactorKit

final class OtherPageReactor: Reactor {
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case updateProfile(item: OtherProfileItem)
    }
    
    struct State {
        @Pulse var profileItem: OtherProfileItem? = nil
    }
    
    var initialState: State
    
    private let repository: OtherPageRequestable
    private let userID: UserID
    init(
        repository: OtherPageRequestable,
        userID: UserID
    ) {
        self.userID = userID
        self.repository = repository
        self.initialState = .init()
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.repository
                .fetchOtherProfile(userID: self.userID)
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { response -> Observable<Mutation> in
                    let item = OtherProfileItem(
                        nickname: response.nickname ?? "",
                        level: response.level ?? 0,
                        profileImageURL: response.profileImageURL,
                        description: response.profileDescription ?? "",
                        tags: response.tags ?? [],
                        representativeWard: response.representativeWard?.name
                    )
                    return .just(.updateProfile(item: item))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .updateProfile(let item):
            _state.profileItem = item
        }
        return _state
    }
}
