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
    
    // TODO: - 1.0.1 이후 수정 필요
    lazy var homeHeaderView: HomeHeaderView = HomeHeaderView(navigationController: self.navigationController!)
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
    
    private let homeEmptyView: DoriDoriEmptyView = DoriDoriEmptyView()
    
    private lazy var reportActionSheetView: ActionSheetAlertController = ActionSheetAlertController(actionModels: ActionSheetAction(title: "신고하기", action: { _ in
        self.viewModel?.action.onNext(.report(type: .question))
    }))
    
    private lazy var deleteActionSheetView: ActionSheetAlertController = ActionSheetAlertController(actionModels: ActionSheetAction(title: "삭제하기", action: { _ in
        self.viewModel?.action.onNext(.deleteMyQuestion)
    }))
    
    private let homeWriteButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "wardWrite"), for: .normal)
        return button
    }()

    private var homeCollectionViewImplement: HomeCollectionViewImplement?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        collectionView.isHidden = true
        setupViews()
        setupConstrinats()
        setup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let homeRepository: HomeRepositoryRequestable = HomeRepository()
        let locationManager = DoriDoriLocationManager()
        viewModel = HomeViewModel(repository: homeRepository, locationManager: locationManager)
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
        
        viewModel?.pulse(\.$shouldShowLocationAlert)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                LocationAlertViewController().show()
            })
            .disposed(by: self.disposeBag)
        
        viewModel?.pulse(\.$needShowReportActionSheetView)
            .skip(1)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                let actionSheetVC = owner.reportActionSheetView.configure()
                owner.present(actionSheetVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel?.pulse(\.$needShowDeleteActionSheetView)
            .skip(1)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                let actionSheetVC = owner.deleteActionSheetView.configure()
                owner.present(actionSheetVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel?.state
            .map { "지금 여기는 \(String($0.wardTitle))!" }
            .distinctUntilChanged()
            .bind(to: homeHeaderView.wardTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        homeWriteButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.writeButtonDidTap()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    private func setupViews() {
        view.addSubview(homeHeaderView)
        view.addSubview(collectionView)
        view.addSubview(homeEmptyView)
        view.addSubview(homeWriteButton)
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
            $0.top.equalTo(homeHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        homeWriteButton.snp.makeConstraints {
            let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
            $0.bottom.equalToSuperview().inset(tabBarHeight + 21)
            $0.trailing.equalToSuperview().inset(30)
            $0.size.equalTo(54)
        }
    }
    
    private func writeButtonDidTap() {
        // TODO: - 강제 언래핑 삭제
        QuestionCoordinator(
            navigationController: self.navigationController!,
            questionType: .community
        ).start()
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
