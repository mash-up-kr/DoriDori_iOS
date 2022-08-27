//
//  OtherProfileContentViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import UIKit
import RxSwift
import RxRelay
import ReactorKit

final class OtherProfileContentViewController: UIViewController,
                                                View {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        return collectionView
    }()
    
    private let viewDidLoadStream: PublishRelay<Void>
    private let reactor: OtherProfileContentReactor
    var disposeBag: DisposeBag
    private let questionItems: BehaviorRelay<[MyPageBubbleItemType]>
    
    init(
        reactor: OtherProfileContentReactor
    ) {
        self.questionItems = .init(value: [])
        self.disposeBag = .init()
        self.reactor = reactor
        self.viewDidLoadStream = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func bind(reactor: OtherProfileContentReactor) {
        self.viewDidLoadStream
            .map { OtherProfileContentReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$questionAndAnswer)
            .bind(to: self.questionItems)
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        self.configure(self.collectionView)
        self.bind()
        self.bind(reactor: self.reactor)
        
        self.viewDidLoadStream.accept(())
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.register(MyPageOtherSpeechBubbleCell.self)
        collectionView.register(MyPageMySpeechBubbleCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayouts() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        self.questionItems
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension OtherProfileContentViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.questionItems.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let item = self.questionItems.value[safe: indexPath.item] else { fatalError("can not find item")
        }
        if let otherSpeechBubbleItem = item as? MyPageOtherSpeechBubbleItemType {
            let cell = collectionView.dequeueReusableCell(type: MyPageOtherSpeechBubbleCell.self, for: indexPath)
            cell.configure(otherSpeechBubbleItem)
            return cell
        }
        if let mySpeechBubbleItem = item as? MyPageMySpeechBubbleCellItem {
            let cell = collectionView.dequeueReusableCell(type: MyPageMySpeechBubbleCell.self, for: indexPath)
            cell.configure(mySpeechBubbleItem)
            return cell
        }
        fatalError("can not casting itemtype")
    }
}

// MARK: - UICollectionViewDelegate

extension OtherProfileContentViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OtherProfileContentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}
