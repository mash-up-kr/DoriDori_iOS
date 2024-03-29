//
//  AnswerCompleteViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/10.
//

import UIKit
import RxRelay
import ReactorKit

final class AnswerCompleteViewController: UIViewController,
                                          View {
    
    // MARK: - UI Component
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    private let refreshControl = UIRefreshControl()
    private let viewDidLoadStream: PublishRelay<Void>
    let reactor: AnswerCompleteReactor
    var disposeBag: DisposeBag
    private let coordinator: MyPageCoordinatable
    private let questionItems: BehaviorRelay<[MyPageBubbleItemType]>
    private let didTapProfile: PublishRelay<IndexPath>
    private let willDisplayCell: PublishRelay<IndexPath>
    private let didSelectCell: PublishRelay<IndexPath>
    private let didTapMoreButton: PublishRelay<IndexPath>
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(self.collectionView)
        self.setupLayouts()
        self.bind()
        self.bind(reactor: self.reactor)
        self.viewDidLoadStream.accept(())
    }
    
    
    init(
        coordinator: MyPageCoordinatable,
        reactor: AnswerCompleteReactor
    ) {
        self.didTapMoreButton = .init()
        self.didSelectCell = .init()
        self.willDisplayCell = .init()
        self.reactor = reactor
        self.coordinator = coordinator
        self.viewDidLoadStream = .init()
        self.disposeBag = .init()
        self.didTapProfile = .init()
        self.questionItems = .init(value: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: AnswerCompleteReactor) {
        self.viewDidLoadStream
            .map { AnswerCompleteReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapProfile
            .map { AnswerCompleteReactor.Action.didTapProfile($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didSelectCell
            .map { AnswerCompleteReactor.Action.didSelectCell($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { AnswerCompleteReactor.Action.didRefresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapMoreButton
            .map { AnswerCompleteReactor.Action.didTapReport($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$questionAndAnswer)
            .bind(to: questionItems)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$navigateUserID)
            .compactMap { $0 }
            .bind(with: self) { owner, userID in
                owner.coordinator.navigateToOtherPage(userID: userID)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$navigateQuestionID)
            .compactMap { $0 }
            .bind(with: self) { owner, value in
                owner.coordinator.navigateToQuestionDetail(questionID: value.questionID, questionUserID: value.questionUserID)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$endRefreshing)
            .compactMap { $0 }
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.refreshControl.endRefreshing()
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$actionSheetAlertController)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, actionSheetController in
                let actionSheet = actionSheetController.configure()
                owner.present(actionSheet, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$showToast)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, text in
                DoriDoriToastView(text: text).show()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        self.questionItems
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, items in
                owner.collectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Private functions
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.register(collectionView)
        collectionView.refreshControl = self.refreshControl
        self.refreshControl.tintColor = .lime300
    }
    
    private func register(_ collectionView: UICollectionView) {
        collectionView.register(MyPageOtherSpeechBubbleCell.self)
        collectionView.register(MyPageMySpeechBubbleCell.self)
        collectionView.register(EmptyCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension AnswerCompleteViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if self.questionItems.value.isEmpty { return 1 }
        return self.questionItems.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if self.questionItems.value.isEmpty {
            let cell = collectionView.dequeueReusableCell(type: EmptyCell.self, for: indexPath)
            cell.configure(title: "받은 질문에 답변을 작성해보아요!")
            return cell
        }
        guard let item = self.questionItems.value[safe: indexPath.item] else { fatalError("can not find item")
        }
        if let otherSpeechBubbleItem = item as? MyPageOtherSpeechBubbleItemType {
            let cell = collectionView.dequeueReusableCell(type: MyPageOtherSpeechBubbleCell.self, for: indexPath)
            cell.configure(otherSpeechBubbleItem)
            cell.bindAction(
                didTapProfile: self.didTapProfile,
                didTapMoreButton: self.didTapMoreButton,
                at: indexPath
            )
            return cell
        }
        
        if let mySpeechBubbleItem = item as? MyPageMySpeechBubbleCellItem {
            let cell = collectionView.dequeueReusableCell(type: MyPageMySpeechBubbleCell.self, for: indexPath)
            cell.configure(mySpeechBubbleItem)
            cell.bindAction(
                didTapProfile: self.didTapProfile,
                didTapMoreButton: self.didTapMoreButton,
                at: indexPath
            )
            return cell
        }
        fatalError("can not casting itemtype")
    }
}

// MARK: - UICollectionViewDelegate

extension AnswerCompleteViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if self.questionItems.value.isEmpty {
            return collectionView.bounds.size
        }
        guard let item = self.questionItems.value[safe: indexPath.item] else { fatalError("can not find item")
        }
        if let otherSpeechBubbleItem = item as? MyPageOtherSpeechBubbleItemType {
            return MyPageOtherSpeechBubbleCell.fittingSize(width: collectionView.bounds.width, item: otherSpeechBubbleItem)
        }
        if let mySpeechBubbleItem = item as? MyPageMySpeechBubbleCellItem {
            return MyPageMySpeechBubbleCell.fittingSize(width: collectionView.bounds.width, item: mySpeechBubbleItem)
        }
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if !self.questionItems.value.isEmpty {
            self.willDisplayCell.accept(indexPath)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if !self.questionItems.value.isEmpty {
            self.didSelectCell.accept(indexPath)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AnswerCompleteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
