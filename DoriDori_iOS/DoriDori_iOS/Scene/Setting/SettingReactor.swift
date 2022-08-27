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
        case didTap(indexPath: IndexPath)
    }
    
    enum Mutation {
        case setSettingSections
        case didTap(item: SettingItem)
    }
    
    struct State {
        @Pulse var settingSections: [SettingSectionModel]
        @Pulse var navigateWeb: DoriDoriWeb? = nil
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
        case .didTap(let indexPath):
            guard let settingItem = self.currentState.settingSections[safe: indexPath.section]?.settingItems[safe: indexPath.item] else { return .empty() }
            return .just(.didTap(item: settingItem))
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
            
        case .didTap(let item):
            switch item {
            case .myLevel: _state.navigateWeb = .myLevel
            case .modifyProfile: _state.navigateWeb = .profileSetting
            case .alarmLocationSetting: _state.navigateWeb = .alarmSetting
            case .notice: _state.navigateWeb = .notice
            case .termsOfService: _state.navigateWeb = .terms
            case .openSource: _state.navigateWeb = .openSource
            default: break
            }
        }
        return _state
    }
}
