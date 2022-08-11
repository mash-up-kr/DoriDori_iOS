//
//  MyPageViewModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import Foundation
import ReactorKit

final class MyPageReactor: Reactor {
    
    enum Action {
        case didSelectTab(index: Int)
        case didScrollToTab(index: Int)
        case didTabSetting
        case didTapShare
        case didTapProfile
        case viewDidLoad
    }
    
    enum Mutation {
        case didSelectTab(index: Int)
    }
    struct State {
        @Pulse var myPageTabs: [MyPageTab]
        var selectedTabIndex: Int
        var myPageTabItems: [MyPageTabCollectionViewCell.Item]
    }

    let initialState: State
    private var selectedTab: MyPageTab
    private let myPageTabs: [MyPageTab]
    
    init(
        myPageTabs: [MyPageTab],
        initialSeletedTab: MyPageTab = .answerComplete
    ) {
        self.myPageTabs = myPageTabs
        self.selectedTab = initialSeletedTab
        
        let selectedTabIndex: Int = myPageTabs.firstIndex(of: initialSeletedTab) ?? 0
        let tabItems = self.myPageTabs.enumerated().map { tabIndex, tab in
            MyPageTabCollectionViewCell.Item(title: tab.title, isSelected: tabIndex == selectedTabIndex)
        }
        self.initialState = State(
            myPageTabs: myPageTabs,
            selectedTabIndex: selectedTabIndex,
            myPageTabItems: tabItems
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.didSelectTab(index: self.initialState.selectedTabIndex))
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
        }
        return _state
    }
}
