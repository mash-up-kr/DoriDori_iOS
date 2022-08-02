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
    
    private let labelList: [String] = []
    
    // MARK: - UIView
    let homeHeaderView: HomeHeaderView = HomeHeaderView()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViews()
        setupConstrinats()
        setup()
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: HomeViewModel) {

    }
    
    // MARK: - Methods
    private func setupViews() {
        self.view.addSubview(homeHeaderView)
    }
    
    private func setupConstrinats() {
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    private func setup() {
        homeHeaderView.locationCollectionView.dataSource = self
        homeHeaderView.locationCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource + UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeued = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath)
        
        guard let cell = dequeued as? LocationCollectionViewCell else {
            return dequeued
        }
        
        cell.locationLabel.text = labelList[indexPath.row]
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as? LocationCollectionViewCell else {
            return .zero
        }

        cell.locationLabel.text = labelList[indexPath.row]
        cell.locationLabel.sizeToFit()

        let cellWidth = cell.locationLabel.frame.width + 20

        return CGSize(width: cellWidth, height: 34)
    }
}
