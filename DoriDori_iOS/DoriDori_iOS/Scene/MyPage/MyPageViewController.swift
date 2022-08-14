//
//  MyPageViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit
import ReactorKit

final class MyPageViewController: UIViewController, View {
    
    // MARK: - UIComponent
    
    private let profileView: MyPageProfileView = MyPageProfileView()
    private let tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray900
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    
    private let selectedLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.backgroundColor = .darkGray
        return stackView
    }()
    
    // MARK: - Properties
    
    var reactor: MyPageReactor
    var disposeBag: DisposeBag
    private let myPageCoordinator: MyPageCoordinatable
    private let didTapMyPageTab: PublishRelay<Int>
    private var myPageTabViewControllers: [UIViewController]
    private var myPageTabItmes: BehaviorRelay<[MyPageTabCollectionViewCell.Item]>
    private let viewDidLoadStream: PublishRelay<Void>
    private let viewWillAppearStream: PublishRelay<Void>
    private let didTapSettingButton: PublishRelay<Void>
    private let didTapShareButton: PublishRelay<Void>
    
    private var lastOffsetX: CGFloat = .zero
    
    // MARK: - Life cycle
    
    init(
        myPageCoordinator: MyPageCoordinatable,
        reactor: MyPageReactor
    ) {
        self.disposeBag = DisposeBag()
        self.myPageCoordinator = myPageCoordinator
        self.reactor = reactor
        self.didTapMyPageTab = .init()
        self.myPageTabItmes = .init(value: [])
        self.myPageTabViewControllers = []
        self.viewDidLoadStream = .init()
        self.viewWillAppearStream = .init()
        self.didTapSettingButton = .init()
        self.didTapShareButton = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.setupViews()
        self.setupTabCollectionView(self.tabCollectionView)
        
        self.bind(reactor: self.reactor)
        self.bind()
        
        self.viewDidLoadStream.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearStream.accept(())
    }

    // MARK: - Bind ViewModel

    func bind(reactor: MyPageReactor) {
        self.bind(action: reactor.action)
        
        reactor.state.map(\.myPageTabItems)
            .distinctUntilChanged()
            .bind(to: self.myPageTabItmes)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$myPageTabs)
            .map { $0.map { $0.viewController} }
            .bind(with: self) { owner, myPageTabViewControllers in
                owner.myPageTabViewControllers = myPageTabViewControllers
                myPageTabViewControllers.forEach(owner.addArrangedSubContentViewController(_:))
            }
            .disposed(by: self.disposeBag)

        reactor.state.map(\.selectedTabIndex)
            .distinctUntilChanged()
            .withLatestFrom(self.myPageTabItmes) { (index: $0, items: $1) }
            .map(\.index)
            .bind(with: self) { owner, index in
                owner.updateSelectedTab(at: index)
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.profileItem)
            .debug("1")
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, profileItem in
                owner.profileView.configure(profileItem)
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.profileItem)
            .debug("2")
            .compactMap { $0 }
            .distinctUntilChanged()
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.profileView.bindAction(
                    didTapSettingButton: owner.didTapSettingButton,
                    didTapShareButton: owner.didTapShareButton
                )
            }
            .disposed(by: self.disposeBag)
    }

    private func bind(action: ActionSubject<MyPageReactor.Action>) {
        
        self.viewDidLoadStream
            .map { MyPageReactor.Action.viewDidLoad }
            .bind(to: action)
            .disposed(by: self.disposeBag)
        
        self.viewWillAppearStream
            .map { MyPageReactor.Action.viewWillAppear }
            .bind(to: action)
            .disposed(by: self.disposeBag)
        
        self.didTapMyPageTab
            .distinctUntilChanged()
            .map { MyPageReactor.Action.didSelectTab(index: $0) }
            .bind(to: action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Bind User Action
    
    private func bind() {
        self.myPageTabItmes
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.tabCollectionView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        self.scrollView.rx.contentOffset
            .map(\.x)
            .compactMap({ [weak self] offsetX -> Int? in
                guard let self = self else { return nil }
                let halfWidth: CGFloat = self.view.bounds.width / 2
                let lastOffsetX = self.lastOffsetX
                var index: Int?
                let remainOffsetX: CGFloat = CGFloat(Int(offsetX) % Int(self.view.bounds.width))
                let isOverOffsetXHalf = ((remainOffsetX / halfWidth) - 1.0) > 0
                
                if (offsetX > lastOffsetX) && isOverOffsetXHalf {
                    index = Int(offsetX / self.view.bounds.width) + 1
                } else if (offsetX < lastOffsetX) && isOverOffsetXHalf {
                    index = Int(offsetX / self.view.bounds.width)
                }

                self.lastOffsetX = offsetX
                return index
            })
            .distinctUntilChanged()
            .bind(to: self.didTapMyPageTab)
            .disposed(by: self.disposeBag)
        
        self.didTapSettingButton
            .debug("didTAp setting button")
            .bind(with: self) { owner, _ in
                owner.myPageCoordinator.navigateToSetting()
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Private functions

extension MyPageViewController {
    
    private func updateSelectedTab(at index: Int) {
        let tabItemCount = CGFloat(self.myPageTabItmes.value.count)
        self.selectedLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(CGFloat(index) * (self.tabCollectionView.bounds.width / tabItemCount))
            if self.selectedLineView.bounds.width == 0 {
                $0.width.equalTo(self.view.bounds.width / tabItemCount)
            }
        }
    }
    
    private func addArrangedSubContentViewController(_ viewController: UIViewController) {
        self.contentStackView.addArrangedSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.view.snp.makeConstraints {
            $0.width.equalTo(self.view.bounds.width)
            $0.height.equalToSuperview()
        }
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .gray900
    }
    
    private func setupTabCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(MyPageTabCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayouts() {
        self.scrollView.addSubViews(self.contentStackView)
        self.contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        self.view.addSubViews(self.profileView, self.tabCollectionView, self.dividerView, self.selectedLineView, self.scrollView)
        
        self.profileView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(144)
        }
        
        self.tabCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
      
        self.dividerView.snp.makeConstraints {
            $0.top.equalTo(self.tabCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        self.selectedLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(0)
            $0.height.equalTo(2)
            $0.bottom.equalTo(self.tabCollectionView.snp.bottom)
        }
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.dividerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MyPageViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.myPageTabItmes.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: MyPageTabCollectionViewCell.self, for: indexPath)
        if let item = self.myPageTabItmes.value[safe: indexPath.item] {
            cell.configure(item)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MyPageViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let offsetX = self.view.bounds.width * CGFloat(indexPath.item)
        self.scrollView.setContentOffset(CGPoint(x: offsetX, y: .zero), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if self.myPageTabItmes.value.isEmpty { return .zero }
        return CGSize(
            width: collectionView.bounds.width / CGFloat(self.myPageTabItmes.value.count),
            height: 52
        )
    }
}
