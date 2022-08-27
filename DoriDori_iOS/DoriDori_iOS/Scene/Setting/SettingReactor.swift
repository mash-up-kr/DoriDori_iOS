//
//  SettingReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import ReactorKit
import Foundation

final class SettingReactor: Reactor {
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setSettingSections
    }
    
    struct State {
        @Pulse var settingSections: [SettingSectionModel]
    }
    
    // MARK: - Properties
    
    var initialState: State
    
    // MARK: - Init
    
    init() {
        self.initialState = State(settingSections: [])
    }
    
    deinit { debugPrint("\(self) deinit") }
    
    // MARK: - Functions
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
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
