//
//  QuestionReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import Foundation
import ReactorKit

typealias Location = (longitude: Double, latitude: Double)

final class QuestionReactor: Reactor {
    
    enum Constant {
        static let maxTextCount = 300
    }

    enum Action {
        case didEditing(text: String)
        case didTapRegistQuestion
        case didSelectNicknameItem(index: Int)
        case didSelectWradItem(index: Int)
        
        case viewDidLoad
    }

    enum Mutation {
        case didEditing(text: String)
        case postQuestion
        case wardListItems(wards: [MyWardDropDownItem])
        case didSelectNicknameItem(index: Int)
        case didSelectWradItem(index: Int)
    }
    
    struct State {
        @Pulse var text: String
        @Pulse var textCount: String
        @Pulse var canRegistQuestion: Bool
        @Pulse var shouldPopViewController: Bool?
        @Pulse fileprivate var location: Location?
        @Pulse var isAnonymous: Bool
        @Pulse var myWardDropDownDataSources: [MyWardDropDownItem]
        @Pulse var nicknameDropDownDataSource: [AnonymousDropDownItem]
    }
    
    let initialState: State
    private let questionType: QuestionType
    private let questionRepository: QuestionRequestable
    
    init(
        questionType: QuestionType,
        questionRepository: QuestionRequestable
    ) {
        self.questionRepository = questionRepository
        self.questionType = questionType
        self.initialState = .init(
            text: "",
            textCount: "0/\(Constant.maxTextCount)",
            canRegistQuestion: false,
            shouldPopViewController: nil,
            isAnonymous: false,
            myWardDropDownDataSources: [],
            nicknameDropDownDataSource: AnonymousDropDownItemType.allCases.map { type -> AnonymousDropDownItem in
                AnonymousDropDownItem(type: type, isSelected: type == .nickanme)
            }
        )
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didEditing(let text):
            return .just(.didEditing(text: text))
        case .didTapRegistQuestion:
            return self.postQuestion(questionType: self.questionType)
        case .viewDidLoad:
            return self.fetchWradList()
        case .didSelectNicknameItem(let index):
            return .just(.didSelectNicknameItem(index: index))
        case .didSelectWradItem(let index):
            return .just(.didSelectWradItem(index: index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .didEditing(let text):
            if text.isEmpty { _state.canRegistQuestion = false }
            else { _state.canRegistQuestion = true }
            _state.textCount = self.setupTextCount(count: text.count)
            _state.text = text
        case .postQuestion:
            _state.shouldPopViewController = true
        case .wardListItems(let wards):
            _state.myWardDropDownDataSources = wards
        case .didSelectWradItem(let selectedIndex):
            let myWardDropDownDataSources = _state.myWardDropDownDataSources.enumerated().map { index, item -> MyWardDropDownItem in
                var _item = item
                _item.update(isSelected: (index == selectedIndex))
                if index == selectedIndex {
                    if let longitude = item.longitude,
                       let latitude = item.latitude {
                        _state.location = (longitude: longitude, latitude: latitude)
                    } else {
                        // TODO: 현 위치 가져와서 저장하기
                    }
                }
                return _item
            }
            _state.myWardDropDownDataSources = myWardDropDownDataSources
        case .didSelectNicknameItem(let selectedIndex):
            let nicknameDropDownDataSources = _state.nicknameDropDownDataSource.enumerated().map { index, item -> AnonymousDropDownItem in
                var _item = item
                _item.update(isSelected: (index == selectedIndex))
                if index == selectedIndex {
                    switch item.type {
                    case .nickanme: _state.isAnonymous = false
                    case .anonymous: _state.isAnonymous = true
                    }
                }
                return _item
            }
            _state.nicknameDropDownDataSource = nicknameDropDownDataSources
        }
        return _state
    }
    
    private func setupTextCount(count: Int) -> String {
        return "\(count)/\(Self.Constant.maxTextCount)"
    }
    
    // TODO: 위치 정보가 없으면 현 위치로 보내자.
    private func postQuestion(questionType: QuestionType) -> Observable<Mutation> {
        let questionObservable: Observable<Void>
        switch questionType {
        case .user(let userID):
            questionObservable = self.questionRepository.postQuestion(
                userID: userID,
                content: self.currentState.text,
                longitude: self.currentState.location?.longitude ?? 127.024099,
                latitude: self.currentState.location?.latitude ?? 37.504030,
                anonymous: false
            )
            .map { _ in return }
        case .community:
            questionObservable = self.questionRepository.postQuestion(
                content: self.currentState.text,
                longitude: self.currentState.location?.longitude ?? 127.024099,
                latitude: self.currentState.location?.latitude ?? 37.504030,
                anonymous: self.currentState.isAnonymous
            )
            .map { _ in return }
        }
        return questionObservable
            .catch { error in
                print(error)
                return .empty()
            }
            .flatMapLatest { _ -> Observable<Mutation> in
                return .just(.postQuestion)
            }
    }
    private func fetchWradList() -> Observable<Mutation> {
        self.questionRepository.fetchMyWardList()
            .catch { error in
                print(error)
                return .empty()
            }
            .flatMapLatest { [weak self] wards -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let items = self.transformModelsToItems(wardModels: wards)
                return .just(.wardListItems(wards: items))
            }
    }
    
    private func transformModelsToItems(wardModels: [MyWardModel]) -> [MyWardDropDownItem] {
        var items: [MyWardDropDownItem] = [
            MyWardDropDownItem(
                name: "현위치",
                longitude: nil,
                latitude: nil,
                isSelected: true
            )
        ]
        let wardItems = wardModels.compactMap { ward -> MyWardDropDownItem? in
            guard let name = ward.name,
                  let longitude = ward.longitude,
                  let latitude = ward.latitude else { return nil }
            return MyWardDropDownItem(
                name: name,
                longitude: longitude,
                latitude: latitude,
                isSelected: false
            )
        }
        items.append(contentsOf: wardItems)
        return items
    }
}
