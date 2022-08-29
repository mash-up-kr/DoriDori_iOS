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
    }
    enum Mutation {
        case questionAndAnswers([MyPageBubbleItemType])
    }
    struct State {
        @Pulse var questionAndAnswer: [MyPageBubbleItemType] = []
    }
    
    private let repository: MyPageRequestable
    private var lastQuestionID: QuestionID?
    private var hasNext: Bool = false
    private var isRequesting: Bool = false
    var initialState: State
    
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
        }

    }
    private func configureCells(response: AnswerCompleteModel) -> [MyPageBubbleItemType] {
        let quetsions = response.questions ?? []
        var _questions: [MyPageBubbleItemType] = []
        let questionItems = quetsions.compactMap { question -> [MyPageBubbleItemType]? in
            guard let isAnonymousQuestion = question.anonymous else { return nil }
            let otherSpeechBubbleItem: MyPageOtherSpeechBubbleItemType
            if isAnonymousQuestion {
                otherSpeechBubbleItem = AnonymousMyPageSpeechBubbleCellItem(
                    userID: question.fromUser?.id ?? "",
                    questionID: question.id ?? "",
                    content: question.content ?? "",
                    location: question.representativeAddress ?? "",
                    updatedTime: 1,
                    tags: question.fromUser?.tags ?? [],
                    userName: question.fromUser?.nickname ?? ""
                )
            } else {
                otherSpeechBubbleItem = IdentifiedMyPageSpeechBubbleCellItem(
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

            let mySpeechBubbleItem = MyPageMySpeechBubbleCellItem(
                userID: question.toUser?.id ?? "",
                questionID: question.answer?.id ?? "",
                questioner: question.fromUser?.nickname ?? "",
                userName: question.answer?.user?.nickname ?? "",
                content: question.answer?.content ?? "",
                location: question.answer?.representativeAddress ?? "",
                updatedTime: 1,
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
    
    private func fetchAnswerComplete() -> Observable<Mutation> {
        return self.repository
            .fetchMyAnswerCompleteQuestions(
                lastQuestionID: self.lastQuestionID,
                size: 20
            )
            .catch { error in
                print(error)
                return .empty()
            }
            .flatMapLatest { [weak self] response -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                guard let hasNext = response.hasNext else { return .empty() }
                self.hasNext = hasNext
                let _questions = self.configureCells(response: response)
                self.isRequesting = false
                return .just(.questionAndAnswers(_questions))
            }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .questionAndAnswers(let questions):
            _state.questionAndAnswer = questions
        }
        return _state
    }
}
