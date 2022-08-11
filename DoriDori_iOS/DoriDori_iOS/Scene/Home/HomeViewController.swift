//
//  HomeViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    // MARK: - Variable
    var disposeBag = DisposeBag()
    
    private let labelList: [String] = ["구로구", "영등포구", "안녕하세요", "만나서반가워", "헬로", "바이", "만나서반가워", "헬로", "바이", "만나서반가워", "헬로", "바이"]
     
    // MARK: - UIView
    let homeHeaderView: HomeHeaderView = HomeHeaderView()
    private var viewModel: HomeViewModel?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViews()
        setupConstrinats()
        setup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let homeRepository: HomeRepositoryRequestable = HomeRepository()
        viewModel = HomeViewModel(repository: homeRepository)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind ViewModel

    func bind(reactor: HomeViewModel) {
        viewModel?.pulse(\.$locationCollectionViewNeedReload)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                print(#function)
                owner.homeHeaderView.locationCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    private func setupViews() {
        if let viewModel = viewModel {
            bind(reactor: viewModel)
        }
        
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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - Cell 클릭시 애니메이션
        viewModel?.action.onNext(.requestHeaderViewData)
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
