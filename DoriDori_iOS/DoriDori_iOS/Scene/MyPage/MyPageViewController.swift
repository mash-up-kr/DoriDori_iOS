//
//  MyPageViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit



final class MyPageViewController: UIViewController {

    // MARK: - UIComponent
    
    private let profileView: MyPageProfileView = MyPageProfileView()
    private let answerCompleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("답변완료", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 16)
        return button
    }()
    private let answerRecievedButton: UIButton = {
        let button = UIButton()
        button.setTitle("받은질문", for: .normal)
        button.setTitleColor(UIColor.gray500, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 16)
        return button
    }()
    private let myAnswerButton: UIButton = {
        let button = UIButton()
        button.setTitle("내 질문", for: .normal)
        button.setTitleColor(UIColor.gray500, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 16)
        return button
    }()
    
    private let tabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
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

    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    var disposeBag: DisposeBag
    private let myPageCoordinator: Coordinator
    private var selectedTab: MyPageTab
    private let myPageTabs: [MyPageTab]
    
    // MARK: - Life cycle
    
    init(
        myPageCoordinator: Coordinator,
        myPageTabs: [MyPageTab],
        initialSeletedTab: MyPageTab = .answerComplete
    ) {
        self.disposeBag = DisposeBag()
        self.selectedTab = initialSeletedTab
        self.myPageCoordinator = myPageCoordinator
        self.myPageTabs = myPageTabs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .gray900
        self.setupTabStackView()
        self.setupLayouts()
        self.setupPageViewController()
    }
    
    private func setupLayouts() {
        self.view.addSubViews(self.profileView, self.tabStackView, self.dividerView, self.selectedLineView, self.pageViewController.view)
        self.profileView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(144)
        }
        self.tabStackView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        self.dividerView.snp.makeConstraints {
            $0.top.equalTo(self.tabStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        self.selectedLineView.snp.makeConstraints {
            $0.top.equalTo(self.tabStackView.snp.bottom)
            $0.centerX.equalTo(self.answerCompleteButton.snp.centerX)
            $0.width.equalTo(UIScreen.main.bounds.width / 3)
            $0.height.equalTo(2)
        }
        self.pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.dividerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTabStackView() {
        [self.answerCompleteButton, self.answerRecievedButton, self.myAnswerButton].forEach { button in
            self.tabStackView.addArrangedSubview(button)
        }
    }
    
    private func setupPageViewController() {
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.addChild(self.pageViewController)
        self.pageViewController.didMove(toParent: self)
        
        let initalViewController = self.selectedTab.viewController
        self.pageViewController.setViewControllers(
            [initalViewController],
            direction: .forward,
            animated: true
        )
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: MyPageViewModel) {

    }
    
    // MARK: - Bind Action
    
    private func bind() {
        
    }
}

// MARK: - UIPageViewControllerDataSource

extension MyPageViewController: UIPageViewControllerDataSource {
    
    private func findViewControllerIndex(
        _ viewController: UIViewController,
        at tabs: [MyPageTab]
    ) -> Int? {
        let currentViewControllerPageIndex: Int? = tabs.firstIndex { tab in
            tab.viewController == viewController
        }
        return currentViewControllerPageIndex
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
//        guard let currentViewControllerPageIndex = self.findViewControllerIndex(viewController, at: self.myPageTabs) else { return nil }
//        if currentViewControllerPageIndex == 0 { return nil }
//        else { return self.myPageTabs[currentViewControllerPageIndex - 1].viewController }
        return self.myPageTabs[1].viewController
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentViewControllerPageIndex = self.findViewControllerIndex(viewController, at: self.myPageTabs) else { return nil }
        if currentViewControllerPageIndex == self.myPageTabs.count - 1 { return nil }
        else { return self.myPageTabs[currentViewControllerPageIndex + 1].viewController }
    }
}

// MARK: - UIPageViewControllerDelegate

extension MyPageViewController: UIPageViewControllerDelegate {
    
}

/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return MyPageViewController(myPageCoordinator: MyPageCoordinator(navigationController: UINavigationController()))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 8", "iPhone 13 mini"]
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            ViewControllerRepresentable()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
        
    }
}
#endif
*/
