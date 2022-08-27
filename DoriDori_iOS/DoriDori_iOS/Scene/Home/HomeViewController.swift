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
        layout.scrollDirection = .vertical
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(HomeMySpeechBubbleViewCell.self)
        collectionView.register(HomeOtherSpeechBubbleCell.self)
        return collectionView
    }()
    
    private var locationCollectionViewImplement: LocationCollectionViewImplement?
    private var homeCollectionViewImplement: HomeCollectionViewImplement?

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
                owner.homeHeaderView.locationCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel?.pulse(\.$homeCollectionViewNeedReload)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    private func setupViews() {
        view.addSubview(homeHeaderView)
        view.addSubview(collectionView)
    }
    
    private func setupConstrinats() {
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(212)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeHeaderView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setup() {
        if let viewModel = viewModel {
            bind(reactor: viewModel)
            locationCollectionViewImplement = LocationCollectionViewImplement(viewModel: viewModel)
            homeCollectionViewImplement = HomeCollectionViewImplement(viewModel: viewModel)
        }
        
        homeHeaderView.locationCollectionView.dataSource = locationCollectionViewImplement
        homeHeaderView.locationCollectionView.delegate = locationCollectionViewImplement
        
        collectionView.dataSource = homeCollectionViewImplement
        collectionView.delegate = homeCollectionViewImplement
        
        if let viewModel = viewModel {
            rx.viewWillAppear
                .map { _ in .requestHeaderViewData }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
            
            rx.viewWillAppear
                .map { _ in .reqeustHomeData }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
        }
    }
}
