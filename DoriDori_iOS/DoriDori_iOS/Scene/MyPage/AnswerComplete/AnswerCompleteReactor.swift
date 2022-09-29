//
//  AnswerCompleteReactor.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/30.
//

import Foundation
import ReactorKit
import RxSwift
import RxRelay

final class AnswerCompleteReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case willDisplayCell(IndexPath)
        case didSelectCell(IndexPath)
        case didTapProfile(IndexPath)
        case didTapReport(IndexPath)
        case didTapReportButton(type: ReportType, targetID: String)
        case didRefresh
        case didTapDelete(answerID: AnswerID)
    }
    
    enum Mutation {
        case questionAndAnswers([MyPageBubbleItemType])
        case didSelect(questionID: QuestionID, questionUserID: UserID)
        case didTap(UserID)
        case endRefreshing([MyPageBubbleItemType])
        case didTapReport(ActionSheetAlertController)
        case toast(text: String)
    }
    
    struct State {
        @Pulse var questionAndAnswer: [MyPageBubbleItemType] = []
        @Pulse var navigateQuestionID: (questionID: QuestionID, questionUserID: UserID)?
        @Pulse var navigateUserID: UserID?
        @Pulse var endRefreshing: Bool?
        @Pulse var actionSheetAlertController: ActionSheetAlertController?
        @Pulse var showToast: String?
    }
    
    private let repository: MyPageRequestable
    private var lastQuestionID: QuestionID?
    private var hasNext: Bool = false
    private var isRequesting: Bool = false
    var initialState: State
    private var shouldRefreshQuestionAndAnswers: Bool = false
    
    init(
        repository: MyPageRequestable
    ) {
        self.repository = repository
        self.initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchAnswerComplete()
                .flatMapLatest { [weak self] response -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    guard let hasNext = response.hasNext else { return .empty() }
                    self.hasNext = hasNext
                    self.lastQuestionID = response.questions?.last?.id
                    let _questions = self.configureCells(response: response)
                    self.isRequesting = false
                    self.shouldRefreshQuestionAndAnswers = true
                    return .just(.questionAndAnswers(_questions))
                }
            
        case .willDisplayCell(let indexPath):
            if (self.currentState.questionAndAnswer.count < ( indexPath.item + 5)) && self.hasNext {
                if !isRequesting {
                    return self.fetchAnswerComplete()
                        .flatMapLatest { [weak self] response -> Observable<Mutation> in
                            guard let self = self else { return .empty() }
                            guard let hasNext = response.hasNext else { return .empty() }
                            self.hasNext = hasNext
                            self.lastQuestionID = response.questions?.last?.id
                            let _questions = self.configureCells(response: response)
                            self.isRequesting = false
                            return .just(.questionAndAnswers(_questions))
                        }
                }
            }
            
        case .didSelectCell(let indexPath):
            guard let question = self.currentState.questionAndAnswer[safe: indexPath.item] ,
                  let userID = UserDefaults.userID else { return .empty() }
            if let myAnswer = question as? MyPageMySpeechBubbleCellItem {
                return .just(.didSelect(questionID: myAnswer.questionID, questionUserID: myAnswer.userID))
            }
            if let question = question as? MyPageOtherSpeechBubbleItemType {
                return .just(.didSelect(questionID: question.questionID, questionUserID: question.userID))
            }
            return .empty()
            
        case .didTapProfile(let indexPath):
            guard let question = self.currentState.questionAndAnswer[safe: indexPath.item] else { return .empty() }
            if let question = question as? MyPageOtherSpeechBubbleItemType {
                if question is IdentifiedMyPageSpeechBubbleCellItem {  // 익명이 아닐 때만..
                    return .just(.didTap(question.userID))
                }
            }
            return .empty()
            
        case .didTapReport(let indexPath):
            guard let question = self.currentState.questionAndAnswer[safe: indexPath.item] else { return .empty() }
            let actionSheetController: ActionSheetAlertController
            if let question = question as? MyPageOtherSpeechBubbleItemType {
                actionSheetController = ActionSheetAlertController(actionModels: ActionSheetAction(title: "신고하기", action: { [weak self] _ in
                    self?.action.onNext(.didTapReportButton(type:  .question, targetID: question.questionID))
                }))
                
            } else if let myAnswer = question as? MyPageMySpeechBubbleCellItem {
                actionSheetController = ActionSheetAlertController(actionModels: ActionSheetAction(title: "삭제하기", action: { [weak self] _ in
                    self?.action.onNext(.didTapDelete(answerID: myAnswer.questionID))
                }))
                
            } else { return .empty() }
     
            return .just(.didTapReport(actionSheetController))
            
        case .didTapDelete(let answerID):
            return self.repository.deleteAnswer(answerID: answerID)
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { [weak self] _ -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    self.lastQuestionID = nil
                    let newAnswerCompletes = self.fetchAnswerComplete()
                        .flatMapLatest { [weak self] response -> Observable<Mutation> in
                            guard let self = self else { return .empty() }
                            guard let hasNext = response.hasNext else { return .empty() }
                            self.hasNext = hasNext
                            self.lastQuestionID = response.questions?.last?.id
                            let _questions = self.configureCells(response: response)
                            self.isRequesting = false
                            return .just(.questionAndAnswers(_questions))
                        }
                    self.shouldRefreshQuestionAndAnswers = true
                    return .concat(
                        newAnswerCompletes,
                        .just(.toast(text: "삭제되었습니다!"))
                    )
                }
            
        case .didTapReportButton(let type, let questionID):
            return self.repository.requestReport(
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
                self.lastQuestionID = nil
                let newAnswerCompletes = self.fetchAnswerComplete()
                    .flatMapLatest { [weak self] response -> Observable<Mutation> in
                        guard let self = self else { return .empty() }
                        guard let hasNext = response.hasNext else { return .empty() }
                        self.hasNext = hasNext
                        self.lastQuestionID = response.questions?.last?.id
                        let _questions = self.configureCells(response: response)
                        self.isRequesting = false
                        return .just(.questionAndAnswers(_questions))
                    }
                self.shouldRefreshQuestionAndAnswers = true
                return .concat(
                    newAnswerCompletes,
                    .just(.toast(text: "신고되었습니다!"))
                )
            }
            
        case .didRefresh:
            self.lastQuestionID = nil
            return self.repository.fetchMyAnswerCompleteQuestions(lastQuestionID: self.lastQuestionID, size: 20)
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
                    imageURL: question.fromUser?.profileImageURL ?? "",
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
    
    private func fetchAnswerComplete() -> Observable<AnswerCompleteModel> {
        self.isRequesting = true
        return self.repository
            .fetchMyAnswerCompleteQuestions(
                lastQuestionID: self.lastQuestionID,
                size: 20
            )
            .catch { error in
                print(error)
                return .empty()
            }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .questionAndAnswers(let questions):
            if self.shouldRefreshQuestionAndAnswers {
                _state.questionAndAnswer = questions
            } else {
                _state.questionAndAnswer.append(contentsOf: questions)
            }
        case .didSelect(let questionID, let questionUserID):
            _state.navigateQuestionID = (questionID, questionUserID)
        case .didTap(let userID):
            _state.navigateUserID = userID
        case .endRefreshing(let questionAndAnswer):
            _state.questionAndAnswer = questionAndAnswer
            _state.endRefreshing = true
        case .didTapReport(let actionSheetcontroller):
            _state.actionSheetAlertController = actionSheetcontroller
        case .toast(let text):
            _state.showToast = text
        }
        
        self.shouldRefreshQuestionAndAnswers = false
        
        return _state
    }
}
