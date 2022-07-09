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
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .systemPink
        self.setupLayouts()
        self.configure(self.collectionView)
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
        collectionView.register(MyPageCollectionViewCell.self)
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
        collectionView.dequeueReusableCell(type: MyPageCollectionViewCell.self, for: indexPath)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 196)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 148)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    
}
