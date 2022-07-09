//
//  MyPageViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MyPageViewController: UIViewController {

    // MARK: - UIComponent
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkGray
        collectionView.collectionViewLayout = layout
        return collectionView
    }()
    
    var disposeBag = DisposeBag()

    // MARK: - Life cycle
    
    init(myPageCoordinator: Coordinator) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        self.setupLayouts()
    }
    
    private func setupLayouts() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.register(collectionView)
    }
    
    private func register(_ collectionView: UICollectionView) {
        collectionView.register(MyPageHeaderView.self, supplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: MyPageViewModel) {

    }
}

// MARK: - UICollectionViewDataSource

extension MyPageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return .init()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(
            kind: kind,
            type: MyPageHeaderView.self,
            for: indexPath
        )
    }
}

// MARK: - UICollectionViewDelegate

extension MyPageViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    
}
