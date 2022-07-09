//
//  HomeViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    // MARK: - Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UIView
    let homeHeaderView: HomeHeaderView = HomeHeaderView()
    
//    private let collectionView: UICollectionView = {
//        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .vertical
//        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 30, bottom: 0, right: 30)
//        let collectionView: UICollectionView = UICollectionView()
//        collectionView.backgroundColor = .clear
//        collectionView.showsVerticalScrollIndicator = true
////        collectionView.register(<#T##type: Cell.Type##Cell.Type#>)
//        return collectionView
//    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(homeHeaderView)
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
//        self.collectionView.dataSource = self
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: HomeViewModel) {

    }
}
//
//extension HomeViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 100
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
//    }
//}
