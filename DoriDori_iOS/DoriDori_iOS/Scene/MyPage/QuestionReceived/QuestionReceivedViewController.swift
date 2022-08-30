//
//  QuestionReceivedViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/04.
//

import UIKit
import ReactorKit
import RxRelay

final class QuestionReceivedViewController: UIViewController,
                                            View {
    
    // MARK: - UIComponents
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    // MARK: - Properties
    
    var reactor: QuestionReceivedReactor
    var disposeBag: DisposeBag
    private let coordiantor: MyPageCoordinatable
    private let viewDidLoadStream: PublishRelay<Void>
    private let questions: BehaviorRelay<[MyPageOtherSpeechBubbleItemType]>
    private let didTapProfile: PublishRelay<IndexPath>
    private let didTapDenyButton: PublishRelay<IndexPath>
    private let didTapCommentButton: PublishRelay<IndexPath>
    private let didSelectCell: PublishRelay<IndexPath>
    
    init(
        reactor: QuestionReceivedReactor,
        coordiantor: MyPageCoordinatable
    ) {
        self.didSelectCell = .init()
        self.didTapDenyButton = .init()
        self.didTapCommentButton = .init()
        self.didTapProfile = .init()
        self.questions = .init(value: [])
        self.viewDidLoadStream = .init()
        self.reactor = reactor
        self.coordiantor = coordiantor
        self.disposeBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.configure(self.collectionView)
        self.setupLayouts()
        self.bind(reactor: self.reactor)
        self.viewDidLoadStream.accept(())
    }
    
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func bind(reactor: QuestionReceivedReactor) {
        
        self.viewDidLoadStream
            .map { QuestionReceivedReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapProfile
            .map { QuestionReceivedReactor.Action.didTapProfile($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapDenyButton
            .map { QuestionReceivedReactor.Action.didTapDeny($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapCommentButton
            .subscribe(onNext: { indexPath in
                print("didTapCommentButton", indexPath)
            })
            .disposed(by: self.disposeBag)
        
        self.didSelectCell
            .map { QuestionReceivedReactor.Action.didSelectCell($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$receivedQuestions)
            .bind(to: questions)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$navigateUserID)
            .compactMap { $0 }
            .bind(with: self) { owner, userID in
                owner.coordiantor.navigateToOtherPage(userID: userID)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$navigateQuestionID)
            .compactMap { $0 }
            .bind(with: self) { owner, questionID in
                owner.coordiantor.navigateToQuestionDetail(questionID: questionID)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        self.questions
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, questions in
                owner.collectionView.reloadData()
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyPageOtherSpeechBubbleCell.self)
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
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item")
        }
        let cell = collectionView.dequeueReusableCell(type: MyPageOtherSpeechBubbleCell.self, for: indexPath)
        cell.configure(item, shouldHideButtonstackView: false)
        cell.bindAction(
            didTapProfile: self.didTapProfile,
            didTapComment: self.didTapCommentButton,
            didTapDeny: self.didTapDenyButton,
            at: indexPath
        )
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
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item")
        }
        return MyPageOtherSpeechBubbleCell.fittingSize(
            width: collectionView.bounds.width,
            item: item,
            shouldHideButtonstackView: false
        )
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.didSelectCell.accept(indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension QuestionReceivedViewController: UICollectionViewDelegateFlowLayout {
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
