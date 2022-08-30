//
//  NavigationWebViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/25.
//

import UIKit
import RxSwift
import RxCocoa

final class NavigationWebViewController: UIViewController {
    
    // navigation bar UI
    
    private let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray900
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        return button
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .regular, size: 18)
        label.textColor = .white
        return label
    }()
    
    private let questionMoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
    }()
    
    private let webViewController: BaseWebViewController
    private let type: DoriDoriWeb
    private let disposeBag: DisposeBag
    private let coordinator: WebViewCoordinatable
    
    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    init(
        type: DoriDoriWeb,
        title: String? = nil,
        coordinator: WebViewCoordinatable
    ) {
        self.coordinator = coordinator
        self.disposeBag = .init()
        self.type = type
        self.webViewController = BaseWebViewController(path: type.path)
        self.navigationTitleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        
        switch self.type {
        case .questionDetail:
            self.view.backgroundColor = .gray900
            self.navigationBarView.backgroundColor = .gray900
        default:
            self.view.backgroundColor = .darkGray
            self.navigationBarView.backgroundColor = .darkGray
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.bind()
    }
    
    private func setupLayouts() {
        self.view.addSubViews(self.navigationBarView, self.webViewController.view)
        self.addChild(self.webViewController)
        self.webViewController.didMove(toParent: self)
        
        self.navigationBarView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        self.webViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.navigationBarView.addSubViews(self.backButton, self.navigationTitleLabel)
        self.backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().offset(23)
            $0.size.equalTo(24)
            $0.bottom.equalToSuperview().inset(15)
        }
        self.navigationTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.backButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        
        switch self.type {
        case .questionDetail:
            self.setupQuestionDetailView()
        default: break
        }
       
    }
    
    // 질문상세보기
    private func setupQuestionDetailView() {
        self.navigationBarView.addSubview(self.questionMoreButton)
        self.questionMoreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        self.backButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                owner.coordinator.pop()
            }
            .disposed(by: self.disposeBag)
    }
}
