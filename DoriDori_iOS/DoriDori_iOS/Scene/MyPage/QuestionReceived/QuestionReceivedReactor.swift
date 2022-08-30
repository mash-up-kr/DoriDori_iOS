//
//  QuestionReceivedReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/30.
//

import Foundation
import ReactorKit

final class QuestionReceivedReactor: Reactor {
    enum Action {
        case viewDidLoad
        case didTapProfile(IndexPath)
        case didTapDeny(IndexPath)
        case comment(content: String, indexPath: IndexPath)
        case didSelectCell(IndexPath)
        case willDisplayCell(IndexPath)
        case didTapDenyCancel
        case didTapDenyAction(QuestionID)
        case didRefresh
    }
    
    enum Mutation {
        case questions([MyPageOtherSpeechBubbleItemType])
        case didTapProfile(UserID)
        case didSelectQuestion(QuestionID)
        case alert(AlertModel)
        case shouldDismissPresentedViewController
        case endRefreshing([MyPageOtherSpeechBubbleItemType])
        case didDenyQuestion([MyPageOtherSpeechBubbleItemType])
        case toast(text: String)
    }
    
    struct State {
        @Pulse var receivedQuestions: [MyPageOtherSpeechBubbleItemType] = []
        @Pulse var navigateQuestionID: QuestionID?
        @Pulse var navigateUserID: UserID?
        @Pulse var alert: AlertModel?
        @Pulse var shouldDismissPresentedViewController: Void?
        @Pulse var endRefreshing: Bool?
        @Pulse var showToast: String?
    }
    
    var initialState: State
    
    private var lastQuestionID: QuestionID?
    private let myPageRepository: MyPageRequestable
    private var hasNext: Bool = false
    private var isRequesting: Bool = false
    private var isFetchMore: Bool = false
    
    init(
        myPageRepository: MyPageRequestable
    ) {
        self.myPageRepository = myPageRepository
        self.initialState = .init()
    }
  
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchReceivedQuestions(size: 20, lastID: self.lastQuestionID)
            
        case .willDisplayCell(let indexPath):
            if (self.currentState.receivedQuestions.count < ( indexPath.item + 5)) && self.hasNext {
                if !isRequesting {
                    self.isFetchMore = true
                    return self.fetchReceivedQuestions(
                        size: 20,
                        lastID: self.lastQuestionID
                    )
                }
            }
        case .didTapProfile(let indexPath):
            guard let question = self.question(at: indexPath) else { return .empty() }
            if question is IdentifiedMyPageSpeechBubbleCellItem {  // 익명이면 상대방 페이지로 넘어가지못하게
                return .just(.didTapProfile(question.userID))
            }
            
        case .didTapDeny(let indexPath):
            guard let question = self.question(at: indexPath) else { return .empty() }
            let alertModel = AlertModel(
                title: "\(question.userName)의 질문을 거절합니다",
                message: "삭제한 질문은 복구할 수 없어요!",
                normalAction: AlertAction(title: "취소", action: {
                self.action.onNext(.didTapDenyCancel)
            }), emphasisAction: AlertAction(title: "거절하기", action: {
                self.action.onNext(.didTapDenyAction(question.questionID))
            }))
            return .just(.alert(alertModel))
            
        case .didTapDenyCancel:
            return .just(.shouldDismissPresentedViewController)
            
        case .didTapDenyAction(let questionID):
            return self.myPageRepository.denyQuestion(questionID: questionID)
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { [weak self] _ -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    var _questions = self.currentState.receivedQuestions
                    let index: Int? = _questions.firstIndex { item in
                        return item.questionID == questionID
                    }
                    guard let index = index else { return .empty() }
                    _questions.remove(at: index)
                    return .concat(
                        .just(.shouldDismissPresentedViewController),
                        .just(.didDenyQuestion(_questions))
                    )
                }
            
        case .comment(let content, let indexPath):
            if content.count < 1 { return .just(.toast(text: "1글자 이상 입력해주세요")) }
            guard let question = self.question(at: indexPath) else { return .empty() }
            return self.myPageRepository.postComment(to: question.questionID, content: content, location: (127.29, 36.48))
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { [weak self] _ -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    var _questions = self.currentState.receivedQuestions
                    _questions.remove(at: indexPath.item)
                    return .concat(
                        .just(.toast(text: "답변이 등록되었습니다")),
                        .just(.questions(_questions))
                    )
                }
            
        case .didSelectCell(let indexPath):
            guard let question = self.question(at: indexPath) else { return .empty() }
            return .just(.didSelectQuestion(question.questionID))
            
        case .didRefresh:
            self.lastQuestionID = nil
            return self.myPageRepository.fetchReceivedQuestions(size: 20, lastQuestionID: self.lastQuestionID)
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { [weak self] response -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    let questionItems = self.configureCells(response: response)
                    return .just(.endRefreshing(questionItems))
                }
            
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .questions(let questions):
            if self.isFetchMore {
                _state.receivedQuestions.append(contentsOf: questions)
                self.isFetchMore = false
            } else {
                _state.receivedQuestions = questions
            }
        case .didDenyQuestion(let questions):
            _state.receivedQuestions = questions
        case .didTapProfile(let userID):
            _state.navigateUserID = userID
        case .didSelectQuestion(let questionID):
            _state.navigateQuestionID = questionID
        case .alert(let alertModel):
            _state.alert = alertModel
        case .shouldDismissPresentedViewController:
            _state.shouldDismissPresentedViewController = ()
        case .endRefreshing(let questions):
            _state.receivedQuestions = questions
            _state.endRefreshing = true
        case .toast(let text):
            _state.showToast = text
        }
        return _state
    }
}

// MARK: - Private functions

extension QuestionReceivedReactor {
    
    private func question(at indexPath: IndexPath) -> MyPageOtherSpeechBubbleItemType? {
        guard let question = self.currentState.receivedQuestions[safe: indexPath.item] else { return nil }
        return question
    }
    
    private func configureCells(response: ReceivedQuestionModel) -> [MyPageOtherSpeechBubbleItemType] {
        guard let questions = response.questions else { return [] }
        return questions.compactMap { question -> MyPageOtherSpeechBubbleItemType? in
            guard let isAnonymousQuestion = question.anonymous else { return nil }
            guard let createdAt = question.createdAt,
                  let updatedTime = DoriDoriDateFormatter(dateString: createdAt).createdAtText() else { return nil }
            if isAnonymousQuestion {
                return AnonymousMyPageSpeechBubbleCellItem(
                    userID: question.fromUser?.id ?? "",
                    questionID: question.id ?? "",
                    content: question.content ?? "",
                    location: question.representativeAddress ?? "",
                    updatedTime: updatedTime,
                    tags: question.fromUser?.tags ?? [],
                    userName: question.fromUser?.nickname ?? ""
                )
            } else {
                return IdentifiedMyPageSpeechBubbleCellItem(
                    userID: question.fromUser?.id ?? "",
                    questionID: question.id ?? "",
                    content: question.content ?? "",
                    location: question.representativeAddress ?? "",
                    updatedTime: updatedTime,
                    level: question.fromUser?.level ?? 1,
                    imageURL: URL(string: question.fromUser?.profileImageURL ?? ""),
                    tags: question.fromUser?.tags ?? [],
                    userName: question.fromUser?.nickname ?? ""
                )
            }
        }
    }
    
    private func fetchReceivedQuestions(size: Int, lastID: QuestionID?) -> Observable<Mutation> {
        self.isRequesting = true
        return self.myPageRepository.fetchReceivedQuestions(
            size: size,
            lastQuestionID: lastID
            )
            .catch { error in
                print(error)
                return .empty()
            }
            .flatMapLatest { [weak self] response -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let questionItems = self.configureCells(response: response)
                self.hasNext = response.hasNext ?? false
                self.isRequesting = false
                self.lastQuestionID = response.questions?.last?.id
                return .just(.questions(questionItems))
            }
    }
}
