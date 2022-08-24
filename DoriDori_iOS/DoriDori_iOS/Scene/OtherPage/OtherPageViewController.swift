//
//  OtherPageViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import ReactorKit

final class OtherPageViewController: UIViewController,
                                     View {
    
    // MARK: - UIComponents
    
    private let profileView = OtherProfileView()
    private let profileDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    
    // MARK: - Properties

    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    private let viewDidLoadStream: PublishRelay<Void>
    private let reactor: OtherPageReactor
    private let coordinator: OtherPageCoordinator
    var disposeBag: DisposeBag
    
    // MARK: - LifeCycles
    
    init(
        reactor: OtherPageReactor,
        coordinator: OtherPageCoordinator
    ) {
        self.reactor = reactor
        self.coordinator = coordinator
        self.viewDidLoadStream = .init()
        self.disposeBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.setupUI()
//        self.profileView.configure(OtherProfileItem(nickname: "도리를찾아서", level: 1, profileImageURL: nil, description: "ㅇㄴ녕하세요 디즈니 영화 다 추천해드려요", tags: ["디즈니", "영화", "애니메이션"], representativeWard: "강남구"))
        self.bind(reactor: self.reactor)
        self.viewDidLoadStream.accept(())
    }
    
    func bind(reactor: OtherPageReactor) {
        self.bind(action: reactor.action)
        
        reactor.pulse(\.$profileItem)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, profileItem in
                owner.profileView.configure(profileItem)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bind(action: ActionSubject<OtherPageReactor.Action>) {
        self.viewDidLoadStream
            .map { OtherPageReactor.Action.viewDidLoad }
            .bind(to: action)
            .disposed(by: self.disposeBag)
    }
    


    private func setupLayouts() {
        let contentViewController = OtherProfileContentViewController()
        
        self.view.addSubViews(self.profileView, self.profileDividerView, contentViewController.view)
        self.profileView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        self.profileDividerView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        contentViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.profileDividerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .gray900
        self.navigationController?.navigationBar.isHidden = true
    }
}
