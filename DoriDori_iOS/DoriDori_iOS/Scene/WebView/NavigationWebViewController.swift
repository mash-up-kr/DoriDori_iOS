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
    private var type: DoriDoriWeb?
    private let disposeBag: DisposeBag
    private let coordinator: WebViewCoordinatable
    private let repository: QuestionPostDetailRequestable
    
    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    init(
        type: DoriDoriWeb,
        title: String? = nil,
        coordinator: WebViewCoordinatable,
        repository: QuestionPostDetailRequestable = QuestionPostDetailRepository()
    ) {
        self.repository = repository
        self.coordinator = coordinator
        self.disposeBag = .init()
        self.type = type
        self.webViewController = BaseWebViewController(path: type.path)
        self.navigationTitleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    init(
        path: String,
        title: String? = nil,
        coordinator: WebViewCoordinatable,
        repository: QuestionPostDetailRequestable = QuestionPostDetailRepository()
    ) {
        self.repository = repository
        self.coordinator = coordinator
        self.disposeBag = .init()
        self.webViewController = BaseWebViewController(path: path)
        self.navigationTitleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { debugPrint("\(self) deinit")}
    
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
        case .questionDetail, .postDetail:
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
        
        self.questionMoreButton.rx.throttleTap
            .compactMap { [weak self] _ -> [ActionSheetAction]? in
                guard let self = self,
                      let userID = UserDefaults.userID else { return nil }
                switch self.type {
                case .postDetail(let postID, let postUserID):
                    let items: [DoriDoriQuestionPostDetailMore]
                    if userID == postUserID { items = [.delete] }
                    else { items = [.report, .block] }
                    return items.map { item in
                            .init(title: item.title, action: { _ in
                                switch item {
                                case .delete:
                                    self.repository.deletePost(postID: postID)
                                        .filter { $0 }
                                        .observe(on: MainScheduler.instance)
                                        .bind(with: self, onNext: { owner, _ in
                                            owner.coordinator.pop()
                                        })
                                        .disposed(by: self.disposeBag)
                                case .block:
                                    self.blockUser(userID: postUserID)
                                default: break
                                }
                            })
                    }
                case .questionDetail(let questionID, let questionUserID):
                    let items: [DoriDoriQuestionPostDetailMore]
                    if userID == questionUserID { items = [.modify, .delete] }
                    else { items = [.report, .block] }
                    return items.map { item in
                            .init(title: item.title, action: { _ in
                                switch item {
                                case .delete:
                                    self.repository.deleteQuestion(questionID: questionID)
                                        .filter { !$0.isEmpty }
                                        .observe(on: MainScheduler.instance)
                                        .bind(with: self, onNext: { owner, _ in
                                            owner.coordinator.pop()
                                        })
                                        .disposed(by: self.disposeBag)
                                case .block:
                                    self.blockUser(userID: questionUserID)
                                default: break
                                }
                            })
                    }
                default: return nil
                }
            }
            .bind(with: self) { owner, actions in
                let actionSheetViewController = ActionSheetAlertController(actionModels: actions).configure()
                owner.present(actionSheetViewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func blockUser(userID: UserID) {
        self.repository.blockUser(userID: userID)
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                DoriDoriToastView(text: "해당 글쓴이를 차단했습니다.").show()
            }
            .disposed(by: self.disposeBag)
    }
}
