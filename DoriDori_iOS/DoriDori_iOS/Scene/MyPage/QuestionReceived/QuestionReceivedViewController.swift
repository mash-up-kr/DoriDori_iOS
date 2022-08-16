//
//  QuestionReceivedViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/04.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxRelay

final class QuestionReceivedViewController: UIViewController,
                                            View {
    
    // MARK: - UIComponents
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .darkGray
        return collectionView
    }()
    
    // MARK: - Properties
    var reactor: QuestionReceivedReactor
    var disposeBag: DisposeBag
    private let viewDidLoadStream: PublishRelay<Void>
    private let questions: BehaviorRelay<[MyPageOtherSpeechBubbleItemType]>
    private let didTapMoreButton: PublishRelay<Int>
    private let didTapCommentButton: PublishRelay<Int>
    private let didTapRefuseButton: PublishRelay<Int>
    
    // MARK: - LifeCycels
    
    init(
        questionReceivedReactor: QuestionReceivedReactor
    ) {
        self.didTapMoreButton = .init()
        self.didTapCommentButton = .init()
        self.didTapRefuseButton = .init()
        self.reactor = questionReceivedReactor
        self.disposeBag = .init()
        self.viewDidLoadStream = .init()
        self.questions = .init(value: [])
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.configure(self.collectionView)
        self.bind()
        self.bind(reactor: self.reactor)
        
        self.viewDidLoadStream.accept(())
    }
    
    func bind(reactor: QuestionReceivedReactor) {
        self.bind(action: reactor.action)
        self.bind(state: reactor.state)
    }
}

// MARK: - Private functions

extension QuestionReceivedViewController {
    
    private func bind(action: ActionSubject<QuestionReceivedReactor.Action>) {
        self.viewDidLoadStream
            .map { QuestionReceivedReactor.Action.viewDidLoad }
            .bind(to: action)
            .disposed(by: self.disposeBag)
    }
    
    private func bind(state: Observable<QuestionReceivedReactor.State>) {
        state.map(\.questions)
            .bind(to: self.questions)
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        self.questions
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
        
        self.didTapMoreButton
            .map { index -> UIAlertController in
                let reportAction = ActionSheetAction(title: "신고하기") { _ in
                    print("\(index) 번 째에 신고하기가 눌렸다!")
                }
                let alertController = ActionSheetAlertController(actionModels: reportAction, neededCancel: true).configure()
                return alertController
            }
            .bind(with: self) { owner, alertcontroller in
                owner.present(alertcontroller, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.didTapCommentButton
            .bind(with: self) { owner, index in
                print(index, "번 째 답변하기가 눌렸다!")
            }
            .disposed(by: self.disposeBag)
        
        self.didTapRefuseButton
            .bind(with: self) { owner, index in
                print("\(index) 번 째 거절하기가 눌렸다!")
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setupLayouts() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.register(MyPageOtherSpeechBubbleCell.self)
        collectionView.register(HomeOtherSpeechBubbleCell.self)
    
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension QuestionReceivedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.questions.value.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item") }
        let cell = collectionView.dequeueReusableCell(type: MyPageOtherSpeechBubbleCell.self, for: indexPath)
        
        cell.didTapMoreButton = { [weak self] in
            self?.didTapMoreButton.accept(indexPath.item)
        }
        cell.didTapCommentButton = { [weak self] in
            self?.didTapCommentButton.accept(indexPath.item)
        }
        cell.didTapRefuseButton = { [weak self] in
            self?.didTapRefuseButton.accept(indexPath.item)
        }
        cell.configure(item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension QuestionReceivedViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item") }
        let size = MyPageOtherSpeechBubbleCell.fittingSize(
            width: collectionView.bounds.width,
            item: item
        )
        return size
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension QuestionReceivedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}
