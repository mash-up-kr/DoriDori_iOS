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

//    private let pageViewController = UIPageViewController(
//        transitionStyle: .scroll,
//        navigationOrientation: .horizontal
//    )
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
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
    
    // MARK: Properties
    
    var reactor: MyPageReactor
    var disposeBag: DisposeBag
    private let myPageCoordinator: Coordinator
    private let didTapMyPageTab: PublishRelay<Int>
    private var myPageTabViewControllers: [UIViewController]
    private var myPageTabItmes: BehaviorRelay<[MyPageTabCollectionViewCell.Item]>
    private var currentTabIndex: Int
    private let viewDidLoadStream: PublishRelay<Void>
    private let currentTabViewController: BehaviorRelay<UIViewController?>
    private let didScrollToTab: PublishRelay<Int>
    private let shouldSelectIndex: PublishRelay<Int> = .init()
    private var canObservePageViewControllerOffset: Bool = true
    var lastOffsetX: CGFloat = .zero
    
    // MARK: - Life cycle
    
    init(
        myPageCoordinator: Coordinator,
        reactor: MyPageReactor
    ) {
        self.currentTabViewController = .init(value: nil)
        self.disposeBag = DisposeBag()
        self.myPageCoordinator = myPageCoordinator
        self.didTapMyPageTab = .init()
        self.myPageTabItmes = .init(value: [])
        self.myPageTabViewControllers = []
        self.reactor = reactor
        self.currentTabIndex = .init()
        self.viewDidLoadStream = .init()
        self.didScrollToTab = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.setupViews()
        self.scrollView.isPagingEnabled = true
        self.setupTabCollectionView(self.tabCollectionView)
        
        self.bind(reactor: self.reactor)
        self.bind()
        
        self.viewDidLoadStream.accept(())
    }

    // MARK: - Bind ViewModel

    func bind(reactor: MyPageReactor) {
        self.bind(action: reactor.action)
        
        reactor.state.map { $0.myPageTabItems}
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.myPageTabItmes)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$myPageTabs)
            .map { $0.map { $0.viewController} }
            .bind(onNext: { [weak self] myPageTabViewControllers in
                guard let self = self else { return }
                self.myPageTabViewControllers = myPageTabViewControllers
                myPageTabViewControllers.forEach { viewCon in
                    self.contentStackView.addArrangedSubview(viewCon.view)
                    self.addChild(viewCon)
                    viewCon.didMove(toParent: self)
                    viewCon.view.snp.makeConstraints {
                        $0.width.equalTo(UIScreen.main.bounds.width)
                        $0.height.equalToSuperview()
                    }
                }
            })
            .disposed(by: self.disposeBag)

        reactor.state.map(\.selectedTabIndex)
            .distinctUntilChanged()
            .withUnretained(self) { (owner: $0, index: $1) }
            .bind(onNext: { owner, index in
                owner.updateSelectedTab(at: index)
            })
            .disposed(by: self.disposeBag)
    }

    private func bind(action: ActionSubject<MyPageReactor.Action>) {
        
        self.viewDidLoadStream
            .map { MyPageReactor.Action.viewDidLoad }
            .bind(to: action)
            .disposed(by: self.disposeBag)
        
        self.didTapMyPageTab
            .distinctUntilChanged()
            .do(onNext: { [weak self] index in
                self?.currentTabIndex = index
            })
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
        
        self.shouldSelectIndex
            .bind(with: self) { owner, index in
                owner.didTapMyPageTab.accept(index)
            }
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
    }
}

// MARK: - Private functions

extension MyPageViewController {
    
    private func updateSelectedTab(at index: Int) {
        self.selectedLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(index * (Int(self.tabCollectionView.bounds.width) / self.myPageTabItmes.value.count))
            if self.selectedLineView.bounds.width == 0 {
                $0.width.equalTo(UIScreen.main.bounds.width / 3)
            }
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
            $0.top.equalTo(self.tabCollectionView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(0)
            $0.height.equalTo(2)
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
        CGSize(width: collectionView.bounds.width / 3, height: 52)
    }
}
