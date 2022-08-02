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
    
    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .darkGray
        return scrollView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .top
        return stackView
    }()
    
    var disposeBag = DisposeBag()
    private var selectedButtonIndex: Int = 0
    
    // MARK: - Life cycle
    
    init(myPageCoordinator: Coordinator) {
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
        self.setupContentScrollView()
        
        let viewController1 = AnswerCompleteViewController(nibName: nil, bundle: nil)
        self.addChild(viewController1)
        self.containerStackView.addArrangedSubview(viewController1.view)
        viewController1.view.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func setupLayouts() {
        self.view.addSubViews(self.profileView, self.tabStackView, self.dividerView, self.selectedLineView, self.containerScrollView)
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
        self.containerScrollView.snp.makeConstraints {
            $0.top.equalTo(self.dividerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTabStackView() {
        [self.answerCompleteButton, self.answerRecievedButton, self.myAnswerButton].forEach { button in
            self.tabStackView.addArrangedSubview(button)
        }
    }
    
    private func setupContentScrollView() {
        self.containerScrollView.addSubview(self.containerStackView)
        self.containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(3000)
        }
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: MyPageViewModel) {

    }
    
    // MARK: - Bind Action
    
    private func bind() {
        
    }
}
