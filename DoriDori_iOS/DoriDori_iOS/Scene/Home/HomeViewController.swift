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
     
    // MARK: - UIView
    let homeHeaderView: HomeHeaderView = HomeHeaderView()
    private var viewModel: HomeViewModel?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(HomeMySpeechBubbleViewCell.self)
        collectionView.register(HomeOtherSpeechBubbleCell.self)
        return collectionView
    }()
    
    private var locationCollectionViewDataSource: UICollectionViewDataSource?
    private var homeCollectionViewDataSource: UICollectionViewDataSource?

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
            locationCollectionViewDataSource = LocationCollectionViewDataSource(viewModel: viewModel)
            homeCollectionViewDataSource = HomeCollectionViewDataSource(viewModel: viewModel)
        }
        
        self.view.addSubview(homeHeaderView)
        self.view.addSubview(collectionView)
    }
    
    private func setupConstrinats() {
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(272)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setup() {
        homeHeaderView.locationCollectionView.dataSource = locationCollectionViewDataSource
        collectionView.dataSource = homeCollectionViewDataSource
        homeHeaderView.locationCollectionView.delegate = self
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - Cell 클릭시 애니메이션
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as? LocationCollectionViewCell else {
            return .zero
        }

        cell.locationLabel.sizeToFit()

        let cellWidth = cell.locationLabel.frame.width + 20

        return CGSize(width: cellWidth, height: 34)
    }
}
