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
    
    // MARK: - LifeCycels
    
    init(
        questionReceivedReactor: QuestionReceivedReactor
    ) {
        self.reactor = questionReceivedReactor
        self.disposeBag = .init()
        self.viewDidLoadStream = .init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.configure(self.collectionView)
        self.bind(reactor: self.reactor)
        self.bind()
        
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
        
    }
    
    private func bind() {
       
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
return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: MyPageOtherSpeechBubbleCell.self, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension QuestionReceivedViewController: UICollectionViewDelegate {
    
}

extension QuestionReceivedViewController: UICollectionViewDelegateFlowLayout {
    
}
