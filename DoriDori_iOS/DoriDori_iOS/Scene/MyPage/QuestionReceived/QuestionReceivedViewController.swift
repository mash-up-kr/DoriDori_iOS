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
    
    init(
        reactor: QuestionReceivedReactor,
        coordiantor: MyPageCoordinatable
    ) {
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
        
        reactor.pulse(\.$receivedQuestions)
            .bind(to: questions)
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
        cell.bindAction(didTapProfile: self.didTapProfile, at: indexPath)
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
            item: item
        )
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
        UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}
