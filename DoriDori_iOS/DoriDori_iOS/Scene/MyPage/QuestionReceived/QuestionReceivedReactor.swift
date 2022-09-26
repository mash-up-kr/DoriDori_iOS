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
        case didTapReport(IndexPath)
        case didTapReportAction(type: ReportType, questionID: QuestionID)
    }
    
    enum Mutation {
        case questions([MyPageOtherSpeechBubbleItemType])
        case didTapProfile(UserID)
        case didSelectQuestion(questionID: QuestionID, questionUserID: UserID)
        case alert(AlertModel)
        case shouldDismissPresentedViewController
        case endRefreshing([MyPageOtherSpeechBubbleItemType])
        case didDenyQuestion([MyPageOtherSpeechBubbleItemType])
        case toast(text: String)
        case didTapReport(ActionSheetAlertController)
    }
    
    struct State {
        @Pulse var receivedQuestions: [MyPageOtherSpeechBubbleItemType] = []
        @Pulse var navigateQuestionID: (questionID: QuestionID, questionUserID: UserID)?
        @Pulse var navigateUserID: UserID?
        @Pulse var alert: AlertModel?
        @Pulse var shouldDismissPresentedViewController: Void?
        @Pulse var endRefreshing: Bool?
        @Pulse var showToast: String?
        @Pulse var actionSheetAlertController: ActionSheetAlertController?
    }
    
    var initialState: State
    
    private let locationManager: LocationManager
    private var lastQuestionID: QuestionID?
    private let myPageRepository: MyPageRequestable
    private var hasNext: Bool = false
    private var isRequesting: Bool = false
    private var isFetchMore: Bool = false
    
    init(
        myPageRepository: MyPageRequestable,
        locationManager: LocationManager
    ) {
        self.myPageRepository = myPageRepository
        self.initialState = .init()
        self.locationManager = locationManager
    }
  
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchReceivedQuestions(size: 20, lastID: self.lastQuestionID)
                .flatMapLatest { [weak self] response -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    let questionItems = self.configureCells(response: response)
                    self.hasNext = response.hasNext ?? false
                    self.isRequesting = false
                    self.lastQuestionID = response.questions?.last?.id
                    return .just(.questions(questionItems))
                }
            
        case .willDisplayCell(let indexPath):
            if (self.currentState.receivedQuestions.count < ( indexPath.item + 5)) && self.hasNext {
                if !isRequesting {
                    self.isFetchMore = true
                    return self.fetchReceivedQuestions(
                        size: 20,
                        lastID: self.lastQuestionID
                    )
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
            
        case .didTapReport(let indexPath):
            let actionSheetController = ActionSheetAlertController(actionModels: ActionSheetAction(title: "신고하기", action: { [weak self] _ in
                guard let question = self?.currentState.receivedQuestions[safe: indexPath.item] else { return }
                
                self?.action.onNext(.didTapReportAction(type: .question, questionID: question.questionID))
            }))
            return .just(.didTapReport(actionSheetController))
            
        case .didTapReportAction(let type, let questionID):
            return self.myPageRepository.requestReport(
                type: type,
                targetID: questionID
            )
            .catch({ error in
                print(error)
                return .empty()
            })
            .filter { $0 }
            .flatMapLatest { [weak self] _ -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let newReceivedQuestions = self.fetchReceivedQuestions(size: 20, lastID: nil)
                    .flatMapLatest { [weak self] response -> Observable<Mutation> in
                        guard let self = self else { return .empty() }
                        let questionItems = self.configureCells(response: response)
                        self.hasNext = response.hasNext ?? false
                        self.isRequesting = false
                        self.lastQuestionID = response.questions?.last?.id
                        return .just(.questions(questionItems))
                    }
                
                return .concat(
                    newReceivedQuestions,
                    .just(.toast(text: "신고되었습니다!"))
                )
            }
            
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
            
            return self.myPageRepository.postComment(
                to: question.questionID,
                content: content,
                location: (UserDefaults.longitude, UserDefaults.latitude)
            )
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
            return .just(.didSelectQuestion(questionID: question.questionID, questionUserID: question.userID))
            
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
        case .didSelectQuestion(let questionID, let questionUserID):
            _state.navigateQuestionID = (questionID, questionUserID)
        case .alert(let alertModel):
            _state.alert = alertModel
        case .shouldDismissPresentedViewController:
            _state.shouldDismissPresentedViewController = ()
        case .endRefreshing(let questions):
            _state.receivedQuestions = questions
            _state.endRefreshing = true
        case .toast(let text):
            _state.showToast = text
        case .didTapReport(let acionSheet):
            _state.actionSheetAlertController = acionSheet
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
    
    private func fetchReceivedQuestions(size: Int, lastID: QuestionID?) -> Observable<ReceivedQuestionModel> {
        self.isRequesting = true
        return self.myPageRepository.fetchReceivedQuestions(
            size: size,
            lastQuestionID: lastID
            )
            .catch { error in
                print(error)
                return .empty()
            }
    }
}
