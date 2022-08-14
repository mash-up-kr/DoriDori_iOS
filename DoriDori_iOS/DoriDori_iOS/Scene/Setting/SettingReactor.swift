//
//  SettingReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import ReactorKit
import Foundation

final class SettingReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewDidLoad
//        case didSelectItem(indexPath: IndexPath)
    }
    
    enum Mutation {
        case setSettingSections
    }
    
    struct State {
        @Pulse var settingSections: [SettingSectionModel]
    }
    
    init() {
        self.initialState = State(settingSections: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            print("viewDidLoad")
            return .just(.setSettingSections)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .setSettingSections:
            let settingSections = [
                SettingSectionModel(title: "내 설정", settingItems: [
                    .myLevel,
                    .modifyProfile,
                    .alarmLocationSetting
                ]),
                SettingSectionModel(title: "앱 설정", settingItems: [
                    .notice,
                    .questionToAdmin,
                    .termsOfService,
                    .openSource,
                    .versionInfo,
                    .logout,
                    .withdraw
                ])
            ]
            _state.settingSections = settingSections
        }
        return _state
    }
}
