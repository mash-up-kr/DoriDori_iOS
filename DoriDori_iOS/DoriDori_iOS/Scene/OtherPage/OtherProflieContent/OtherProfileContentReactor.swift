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
    }
    enum Mutation {
        case quetsions([MyPageBubbleItemType])
        case didSelect(QuestionID)
    }
    struct State {
        @Pulse var questionAndAnswer: [MyPageBubbleItemType] = []
        @Pulse var navigateQuestionID: QuestionID?
    }
    
    var initialState: State
    private let repository: OtherPageRequestable
    private let userID: UserID
    
    init(
        repository: OtherPageRequestable,
        userID: UserID
    ) {
        self.userID = userID
        self.repository = repository
        self.initialState = .init()
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .quetsions(let questions):
            _state.questionAndAnswer = questions
        case .didSelect(let questionID):
            _state.navigateQuestionID = questionID
        }
        return _state
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.repository
                .fetchQuestionAndAnswer(size: 20, userID: self.userID)
                .catch { error in
                    print(error)
                    return .empty()
                }
                .flatMapLatest { response -> Observable<Mutation> in
                    let quetsions = response.questions ?? []
                    var _questions: [MyPageBubbleItemType] = []
                    let questionItems = quetsions.compactMap { question -> [MyPageBubbleItemType]? in
                        guard let isAnonymousQuestion = question.anonymous else { return nil }
                        let otherSpeechBubbleItem: MyPageOtherSpeechBubbleItemType
                        if isAnonymousQuestion {
                            otherSpeechBubbleItem = AnonymousMyPageSpeechBubbleCellItem(
                                questionID: question.id ?? "",
                                content: question.content ?? "",
                                location: question.representativeAddress ?? "",
                                updatedTime: 1,
                                tags: question.fromUser?.tags ?? [],
                                userName: question.fromUser?.nickname ?? ""
                            )
                        } else {
                            otherSpeechBubbleItem = IdentifiedMyPageSpeechBubbleCellItem(
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
                    
                    return .just(.quetsions(_questions))
                }
        case .didSelect(let indexPath):
            guard let question = self.currentState.questionAndAnswer[safe: indexPath.item] else { return .empty() }
            if let myAnswer = question as? MyPageMySpeechBubbleCellItem {
                return .just(.didSelect(myAnswer.questionID))
            }
            if let question = question as? MyPageOtherSpeechBubbleItemType {
                return .just(.didSelect(question.questionID))
            }
            return .empty()
        }
    }
}
