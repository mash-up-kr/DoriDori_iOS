//
//  OtherProfileContentReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/25.
//

import Foundation
import RxRelay
import RxSwift
import ReactorKit

final class OtherProfileContentReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case didSelect(IndexPath)
        case willDisplayCell(IndexPath)
        case didTapProfile(IndexPath)
        case didTapMoreButton(IndexPath)
        case didTapReport(type: ReportType, targetID: String)
    }
    
    enum Mutation {
        case quetsions([MyPageBubbleItemType])
        case didSelect(questionID: QuestionID, isMyQuestion: Bool)
        case didTap(UserID)
        case didTapReport(ActionSheetAlertController)
        case toast(text: String)
    }
    
    struct State {
        @Pulse var questionAndAnswer: [MyPageBubbleItemType] = []
        @Pulse var navigateQuestionID: (questionID: QuestionID, isMyQuestion: Bool)?
        @Pulse var navigateUserID: UserID?
        @Pulse var actionSheetController: ActionSheetAlertController?
        @Pulse var toast: String?
    }
    
    private var shouldRefreshQuestionAndAnswers: Bool = false
    private var hasNext: Bool = false
    private var lastID: String?
    private var isRequesting: Bool = false
    var initialState: State
    private let repository: OtherPageRequestable
    private let userID: UserID
    private let shouldFetchQuestionAndAnswer: PublishRelay<String>
    
    init(
        repository: OtherPageRequestable,
        userID: UserID
    ) {
        self.shouldFetchQuestionAndAnswer = .init()
        self.userID = userID
        self.repository = repository
        self.initialState = .init()
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }

    private func fetchQuestionAndAnswer(size: Int = 20, userID: UserID, lastID: String?) -> Observable<AnswerCompleteModel> {
        return self.repository.fetchQuestionAndAnswer(size: 20, userID: self.userID)
            .do(onNext: { [weak self] _ in
                self?.isRequesting = true
            })
            .catch { error in
                print(error)
                return .empty()
            }
    }
    
    private func configureCells(response: AnswerCompleteModel) -> [MyPageBubbleItemType] {
        let quetsions = response.questions ?? []
        var _questions: [MyPageBubbleItemType] = []
        let questionItems = quetsions.compactMap { question -> [MyPageBubbleItemType]? in
            guard let isAnonymousQuestion = question.anonymous else { return nil }
            guard let createdAt = question.createdAt,
                  let updatedTime = DoriDoriDateFormatter(dateString: createdAt).createdAtText() else { return nil }
            let otherSpeechBubbleItem: MyPageOtherSpeechBubbleItemType
            if isAnonymousQuestion {
                otherSpeechBubbleItem = AnonymousMyPageSpeechBubbleCellItem(
                    userID: question.fromUser?.id ?? "",
                    questionID: question.id ?? "",
                    content: question.content ?? "",
                    location: question.representativeAddress ?? "",
                    updatedTime: updatedTime,
                    tags: question.fromUser?.tags ?? [],
                    userName: question.fromUser?.nickname ?? ""
                )
            } else {
                otherSpeechBubbleItem = IdentifiedMyPageSpeechBubbleCellItem(
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
            guard let createdAt = question.answer?.createdAt,
                  let updatedTime = DoriDoriDateFormatter(dateString: createdAt).createdAtText() else { return nil }
            let mySpeechBubbleItem = MyPageMySpeechBubbleCellItem(
                userID: question.toUser?.id ?? "",
                questionID: question.answer?.id ?? "",
                questioner: question.fromUser?.nickname ?? "",
                userName: question.answer?.user?.nickname ?? "",
                content: question.answer?.content ?? "",
                location: question.answer?.representativeAddress ?? "",
                updatedTime: updatedTime,
                likeCount: question.answer?.likeCount ?? 0,
                profileImageURL: URL(string: question.answer?.user?.profileImageURL ?? ""),
                level: question.answer?.user?.level ?? 1
            )
            let myPageBubble: [MyPageBubbleItemType] = [otherSpeechBubbleItem, mySpeechBubbleItem]
            return myPageBubble
        }
        questionItems.forEach { questions in
            _questions.append(contentsOf: questions)
        }
        return _questions
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchQuestionAndAnswer(
                userID: self.userID,
                lastID: self.lastID
            )
            .flatMapLatest { [weak self] response -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                guard let hasNext = response.hasNext else { return .empty() }
                self.hasNext = hasNext
                let _questions = self.configureCells(response: response)
                self.isRequesting = false
                self.shouldRefreshQuestionAndAnswers = true
                return .just(.quetsions(_questions))
            }
            
        case .didSelect(let indexPath):
            guard let question = self.currentState.questionAndAnswer[safe: indexPath.item],
                  let userID = UserDefaults.userID else { return .empty() }
            if let myAnswer = question as? MyPageMySpeechBubbleCellItem {
                return .just(.didSelect(questionID: myAnswer.questionID, isMyQuestion: userID == myAnswer.userID))
            }
            if let question = question as? MyPageOtherSpeechBubbleItemType {
                return .just(.didSelect(questionID: question.questionID, isMyQuestion: userID == question.userID))
            }
            return .empty()
         
        case .didTapProfile(let indexPath):
            guard let question = self.currentState.questionAndAnswer[safe: indexPath.item] else { return .empty() }
            if let myAnswer = question as? MyPageMySpeechBubbleCellItem {
                return .just(.didTap(myAnswer.userID))
            }
            if let question = question as? MyPageOtherSpeechBubbleItemType {
                return .just(.didTap(question.userID))
            }
            return .empty()
            
        case .didTapMoreButton(let indexPath):
            let actionSheet: ActionSheetAlertController
            guard let question = self.currentState.questionAndAnswer[safe: indexPath.item] else { return .empty() }
            if let answer = question as? MyPageMySpeechBubbleCellItem {
                actionSheet = ActionSheetAlertController(actionModels: ActionSheetAction(title: "신고하기", action: { [weak self] _ in
                    self?.action.onNext(.didTapReport(type: .answer, targetID: answer.questionID))
                }))
            } else if let question = question as? MyPageOtherSpeechBubbleItemType {
                actionSheet = ActionSheetAlertController(actionModels: ActionSheetAction(title: "신고하기", action: { [weak self] _ in
                    self?.action.onNext(.didTapReport(type: .question, targetID: question.questionID))
                }))
            } else { return .empty() }
            
            return .just(.didTapReport(actionSheet))
            
        case .willDisplayCell(let indexPath):
            if (self.currentState.questionAndAnswer.count < ( indexPath.item + 5)) && self.hasNext {
                return self.fetchQuestionAndAnswer(
                    userID: self.userID,
                    lastID: self.lastID
                )
                .flatMapLatest { [weak self] response -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    guard let hasNext = response.hasNext else { return .empty() }
                    self.hasNext = hasNext
                    let _questions = self.configureCells(response: response)
                    self.isRequesting = false
                    return .just(.quetsions(_questions))
                }
            } else { return .just(.quetsions([])) }
            
        case .didTapReport(let type, let targetID):
            let newQuestionAndAnswers = self.repository.requestReport(type: type, targetID: targetID)
                .catch({ error in
                    print(error)
                    return .empty()
                })
                .filter { $0 }
                .flatMapLatest { [weak self] _ -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    return self.fetchQuestionAndAnswer(
                        userID: self.userID,
                        lastID: nil
                    )
                    .flatMapLatest { [weak self] response -> Observable<Mutation> in
                        guard let self = self else { return .empty() }
                        guard let hasNext = response.hasNext else { return .empty() }
                        self.hasNext = hasNext
                        let _questions = self.configureCells(response: response)
                        self.isRequesting = false
                        return .just(.quetsions(_questions))
                    }
                }
            self.shouldRefreshQuestionAndAnswers = true
            return .concat(
                newQuestionAndAnswers,
                .just(.toast(text: "신고되었습니다!"))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .quetsions(let questions):
            if self.shouldRefreshQuestionAndAnswers {
                _state.questionAndAnswer = questions
            } else {
                _state.questionAndAnswer.append(contentsOf: questions)
            }
        case .didSelect(let questionID, let isMyQuestion):
            _state.navigateQuestionID = (questionID, isMyQuestion)
        case .didTap(let userID):
            _state.navigateUserID = userID
        case .didTapReport(let actionSheetcontroller):
            _state.actionSheetController = actionSheetcontroller
        case .toast(let text):
            _state.toast = text
        }
        
        self.shouldRefreshQuestionAndAnswers = false
        
        return _state
    }
    
}
