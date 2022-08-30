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
        case didTapComment(IndexPath)
        case didSelectCell(IndexPath)
        case didTapDenyCancel
        case didTapDenyAction(QuestionID)
    }
    
    enum Mutation {
        case questions([MyPageOtherSpeechBubbleItemType])
        case didTapProfile(UserID)
        case didSelectQuestion(QuestionID)
        case alert(AlertModel)
        case shouldDismissPresentedViewController
    }
    
    struct State {
        @Pulse var receivedQuestions: [MyPageOtherSpeechBubbleItemType] = []
        @Pulse var navigateQuestionID: QuestionID?
        @Pulse var navigateUserID: UserID?
        @Pulse var alert: AlertModel?
        @Pulse var shouldDismissPresentedViewController: Void?
    }
    
    var initialState: State
    
    private var lastQuestionID: QuestionID?
    private let myPageRepository: MyPageRequestable
    init(
        myPageRepository: MyPageRequestable
    ) {
        self.myPageRepository = myPageRepository
        self.initialState = .init()
    }
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.myPageRepository.fetchReceivedQuestions(size: 20, lastQuestionID: self.lastQuestionID)
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { response -> Observable<Mutation> in
                    guard let questions = response.questions else { return .just(.questions([])) }
                    let questionItems = questions.compactMap { question -> MyPageOtherSpeechBubbleItemType? in
                        guard let isAnonymousQuestion = question.anonymous else { return nil }
                        if isAnonymousQuestion {
                            return AnonymousMyPageSpeechBubbleCellItem(
                                userID: question.fromUser?.id ?? "",
                                questionID: question.id ?? "",
                                content: question.content ?? "",
                                location: question.representativeAddress ?? "",
                                updatedTime: 1,
                                tags: question.fromUser?.tags ?? [],
                                userName: question.fromUser?.nickname ?? ""
                            )
                        } else {
                            return IdentifiedMyPageSpeechBubbleCellItem(
                                userID: question.fromUser?.id ?? "",
                                questionID: question.id ?? "",
                                content: question.content ?? "",
                                location: question.representativeAddress ?? "",
                                updatedTime: 1,
                                level: question.fromUser?.level ?? 1,
                                imageURL: URL(string: question.fromUser?.profileImageURL ?? ""),
                                tags: question.fromUser?.tags ?? [],
                                userName: question.fromUser?.nickname ?? ""
                            )
                        }
                    }
                    return .just(.questions(questionItems))
                }
        case .didTapProfile(let indexPath):
            guard let question = self.question(at: indexPath) else { return .empty() }
            return .just(.didTapProfile(question.userID))
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
                    print("index", index, "번째 거절 성공")
                    return .concat(
                        .just(.shouldDismissPresentedViewController),
                        .just(.questions(_questions))
                    )
                }
        case .didTapComment(let indexPath):
            print("didTapcomment")
        case .didSelectCell(let indexPath):
            guard let question = self.question(at: indexPath) else { return .empty() }
            return .just(.didSelectQuestion(question.questionID))
        }
        return .empty()
    }
    
    private func question(at indexPath: IndexPath) -> MyPageOtherSpeechBubbleItemType? {
        guard let question = self.currentState.receivedQuestions[safe: indexPath.item] else { return nil }
        return question
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .questions(let questions):
            _state.receivedQuestions = questions
        case .didTapProfile(let userID):
            _state.navigateUserID = userID
        case .didSelectQuestion(let questionID):
            _state.navigateQuestionID = questionID
        case .alert(let alertModel):
            _state.alert = alertModel
        case .shouldDismissPresentedViewController:
            _state.shouldDismissPresentedViewController = ()
        }
        return _state
    }
}
