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
    
    private let homeEmptyView: HomeEmptyView = {
        let emptyView: HomeEmptyView = HomeEmptyView()
        emptyView.backgroundColor = .red
        return emptyView
    }()

    private var homeCollectionViewImplement: HomeCollectionViewImplement?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        collectionView.isHidden = true
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
        viewModel?.pulse(\.$homeCollectionViewNeedReload)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel?.pulse(\.$homeEmptyState)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, check in
                if check {
                    owner.collectionView.isHidden = true
                    owner.homeEmptyView.isHidden = false
                } else {
                    owner.collectionView.isHidden = false
                    owner.homeEmptyView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        viewModel?.state
            .map { "지금 여기는 \(String($0.wardTitle))!" }
            .distinctUntilChanged()
            .bind(to: homeHeaderView.wardTitleLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    // MARK: - Methods
    private func setupViews() {
        view.addSubview(homeHeaderView)
        view.addSubview(collectionView)
        view.addSubview(homeEmptyView)
    }
    
    private func setupConstrinats() {
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(152)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeHeaderView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        homeEmptyView.snp.makeConstraints {
            $0.top.equalTo(homeHeaderView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setup() {
        if let viewModel = viewModel {
            bind(reactor: viewModel)
            // TODO: - 일단 HomeVC 생성시에 navigation 넣어줘서 강제 언래핑으로,
            // 추후에 HomeCoordinator로 바꾸기
            homeCollectionViewImplement = HomeCollectionViewImplement(viewModel: viewModel, naviagationController: self.navigationController!)
        }
        
        collectionView.dataSource = homeCollectionViewImplement
        collectionView.delegate = homeCollectionViewImplement
        
        
        if let viewModel = viewModel {
            rx.viewWillAppear
                .map { _ in .reqeustHomeData }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
        }
    }
}
