//
//  MyPageViewModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import Foundation
import ReactorKit
import RxRelay

final class MyPageReactor: Reactor {
    
    enum Action {
        case didSelectTab(index: Int)
        case didScrollToTab(index: Int)
        case didTabSetting
        case didTapShare
        case didTapProfile
                
        case viewDidLoad
        case viewWillAppear
    }
    
    enum Mutation {
        case didSelectTab(index: Int)
        case updateProrilfe(item: MyPageProfileItem)
    }
    struct State {
        @Pulse var myPageTabs: [MyPageTab]
        var selectedTabIndex: Int
        var myPageTabItems: [MyPageTabCollectionViewCell.Item]
        var profileItem: MyPageProfileItem?
    }

    let initialState: State
    private var selectedTab: MyPageTab
    private let myPageTabs: [MyPageTab]
    private let myPageRepository: MyPageRequestable
    private let disposeBag: DisposeBag
    private let didTapSettingButton: PublishRelay<Void>
    
    init(
        myPageTabs: [MyPageTab],
        initialSeletedTab: MyPageTab,
        myPageRepository: MyPageRequestable
    ) {
        self.myPageTabs = myPageTabs
        self.selectedTab = initialSeletedTab
        self.myPageRepository = myPageRepository
        self.disposeBag = DisposeBag()
        
        self.didTapSettingButton = .init()
        
        let selectedTabIndex: Int = myPageTabs.firstIndex(of: initialSeletedTab) ?? 0
        let tabItems = self.myPageTabs.enumerated().map { tabIndex, tab in
            MyPageTabCollectionViewCell.Item(title: tab.title, isSelected: tabIndex == selectedTabIndex)
        }
        self.initialState = State(
            myPageTabs: myPageTabs,
            selectedTabIndex: selectedTabIndex,
            myPageTabItems: tabItems,
            profileItem: nil
        )
    }
    
    private func mutateViewWillAppear() -> Observable<Mutation> {
        return self.myPageRepository.fetchMyProfile()
            .catch({ error in
                // TODO: error 디자인에 맞춰 수정 필요
                return .empty()
            })
            .flatMapLatest({ profileModel -> Observable<Mutation> in
                guard let nickname = profileModel.nickname,
                      let level = profileModel.level,
                      let tags = profileModel.tags else { return .empty() }
                let profileViewItem = MyPageProfileItem(
                    nickname: nickname,
                    level: level,
                    profileImageURL: profileModel.profileImageURL,
                    description: profileModel.profileDescription ?? "",
                    tags: tags
                )
                return .just(.updateProrilfe(item: profileViewItem))
            })
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.didSelectTab(index: self.initialState.selectedTabIndex))
        case .viewWillAppear:
            return self.mutateViewWillAppear()
        case .didSelectTab(let index):
            return .just(.didSelectTab(index: index))
        case .didScrollToTab(let index):
            print("did scroll tab")
            return .just(.didSelectTab(index: index))
        case .didTabSetting:
            print("did tap setting")
        case .didTapProfile:
            print("did tap profile")
        case .didTapShare:
            print("did tap share")
        }
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        
        switch mutation {
        case .didSelectTab(let selectedTabIndex):
            let myPageTabItems = _state.myPageTabItems.enumerated().map { index, item -> MyPageTabCollectionViewCell.Item in
                var _item = item
                _item.update(isSelected: index == selectedTabIndex)
                return _item
            }
            _state.myPageTabItems = myPageTabItems
            _state.selectedTabIndex = selectedTabIndex
        case .updateProrilfe(let profileItem):
            _state.profileItem = profileItem
        }
        return _state
    }
}
