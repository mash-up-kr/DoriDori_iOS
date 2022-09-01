//
//  SettingReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import ReactorKit
import Foundation
import UIKit

final class SettingReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case didTap(indexPath: IndexPath)
        case didTapDenyCancel
        case didTapWithdraw
        case didTapLogout
    }
    
    enum Mutation {
        case setSettingSections
        case didTap(item: SettingItem)
        case shouldDismissPresentedViewController
        case goToWelcomeViewController
    }
    
    struct State {
        @Pulse var settingSections: [SettingSectionModel]
        @Pulse var navigateWeb: DoriDoriWeb? = nil
        @Pulse var showAlert: AlertModel?
        @Pulse var shouldDismissPresentedViewController: Void?
        @Pulse var goToWelcomeViewController: Void?
        @Pulse var navigateToAdminPage: Void?
    }
    
    // MARK: - Properties
    private let settingRepository: SettingRequestable
    var initialState: State
    
    // MARK: - Init
    
    init(settingRepository: SettingRequestable) {
        self.initialState = State(settingSections: [])
        self.settingRepository = settingRepository
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
        case .didTapDenyCancel:
            return .just(.shouldDismissPresentedViewController)
        case .didTapWithdraw:
            return withdrawUser()
        case .didTapLogout:
            return .just(.goToWelcomeViewController)
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
            case .logout: _state.showAlert = AlertModel(title: "도리도리의 접속이 중요합니다.",
                                                        message: "가입했던 계정을 기억해주세요!",
                                                        normalAction: AlertAction(title: "취소", action: { self.action.onNext(.didTapDenyCancel) }),
                                                        emphasisAction: AlertAction(title: "로그아웃", action: { self.action.onNext(.didTapLogout) }))
            case .withdraw: _state.showAlert = AlertModel(title: "도리도리의 계정을 지웁니다",
                                                          message: "작성한 질문, 댓글은 삭제되지 않아요!",
                                                          normalAction: AlertAction(title: "취소", action: { self.action.onNext(.didTapDenyCancel) }),
                                                          emphasisAction: AlertAction(title: "탈퇴", action: { self.action.onNext(.didTapWithdraw) }))
            case .questionToAdmin:
                _state.navigateToAdminPage = ()
            default: break
            }
        case .shouldDismissPresentedViewController:
            _state.shouldDismissPresentedViewController = ()
        case .goToWelcomeViewController:
            _state.goToWelcomeViewController = ()
        }
        return _state
    }
    
}

extension SettingReactor {
    private func withdrawUser() -> Observable<Mutation> {
        return self.settingRepository.userWithdraw()
            .catch { error in
                return .empty()
            }.observe(on: MainScheduler.instance)
            .flatMapLatest { withdraw -> Observable<Mutation> in
                return .just(.goToWelcomeViewController)
            }
    }
}
