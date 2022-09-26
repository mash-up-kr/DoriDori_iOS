//
//  QuestionReceivedViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/04.
//

import UIKit
import ReactorKit
import RxRelay

final class QuestionReceivedViewController: UIViewController,
                                            View {
    
    // MARK: - UIComponents
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    private let refreshControl = UIRefreshControl()
    private let commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray900
        view.isHidden = true
        return view
    }()
    
    private let registButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(UIColor.lime300, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.lime300.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 12)
        return button
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.tintColor = .lime300
        return textField
    }()
    
    // MARK: - Properties
    
    var reactor: QuestionReceivedReactor
    var disposeBag: DisposeBag
    private let coordiantor: MyPageCoordinatable
    private let viewDidLoadStream: PublishRelay<Void>
    private let questions: BehaviorRelay<[MyPageOtherSpeechBubbleItemType]>
    private let didTapProfile: PublishRelay<IndexPath>
    private let didTapDenyButton: PublishRelay<IndexPath>
    private let didTapMoreButton: PublishRelay<IndexPath>
    private let didTapCommentButton: PublishRelay<IndexPath>
    private let didSelectCell: PublishRelay<IndexPath>
    private let willDisplayCell: PublishRelay<IndexPath>
    private var keyboardHeight: CGFloat = .zero
    private let didTapRegistButton: PublishRelay<IndexPath>
    
    init(
        reactor: QuestionReceivedReactor,
        coordiantor: MyPageCoordinatable
    ) {
        self.didTapMoreButton = .init()
        self.didTapRegistButton = .init()
        self.willDisplayCell = .init()
        self.didSelectCell = .init()
        self.didTapDenyButton = .init()
        self.didTapCommentButton = .init()
        self.didTapProfile = .init()
        self.questions = .init(value: [])
        self.viewDidLoadStream = .init()
        self.reactor = reactor
        self.coordiantor = coordiantor
        self.disposeBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.configure(self.collectionView)
        self.setupLayouts()
        self.bind(reactor: self.reactor)
        self.viewDidLoadStream.accept(())
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .bind(with: self) { owner, notification in
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    owner.keyboardHeight = keyboardHeight
                }
            }
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .bind(with: self) { owner, notification in
                owner.textField.resignFirstResponder()
                owner.commentView.isHidden = true
            }
            .disposed(by: self.disposeBag)
        
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func bind(reactor: QuestionReceivedReactor) {
        
        self.viewDidLoadStream
            .map { QuestionReceivedReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapProfile
            .map { QuestionReceivedReactor.Action.didTapProfile($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapMoreButton
            .map { QuestionReceivedReactor.Action.didTapReport($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapDenyButton
            .map { QuestionReceivedReactor.Action.didTapDeny($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didTapCommentButton
            .bind(with: self) { owner, _ in
                owner.textField.becomeFirstResponder()
                owner.textField.text = nil
                owner.commentView.isHidden = false
                owner.commentView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(self.keyboardHeight)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.registButton.rx.throttleTap
            .asObservable()
            .withLatestFrom(self.textField.rx.text.orEmpty)
            .withLatestFrom(self.didTapCommentButton) { ($0, $1) }
            .map { content, indexPath -> QuestionReceivedReactor.Action in
                QuestionReceivedReactor.Action.comment(
                    content: content,
                    indexPath: indexPath
                )
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.willDisplayCell
            .map { QuestionReceivedReactor.Action.willDisplayCell($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.didSelectCell
            .map { QuestionReceivedReactor.Action.didSelectCell($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { QuestionReceivedReactor.Action.didRefresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$receivedQuestions)
            .bind(to: questions)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$navigateUserID)
            .compactMap { $0 }
            .bind(with: self) { owner, userID in
                owner.coordiantor.navigateToOtherPage(userID: userID)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$navigateQuestionID)
            .compactMap { $0 }
            .bind(with: self) { owner, value in
                owner.coordiantor.navigateToQuestionDetail(questionID: value.questionID, isMyQuestion: value.isMyQuestion)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$alert)
            .compactMap { $0 }
            .bind(with: self) { owner, alertModel in
                AlertViewController(model: alertModel)
                    .show()
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$shouldDismissPresentedViewController)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$endRefreshing)
            .compactMap { $0 }
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.refreshControl.endRefreshing()
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$showToast)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, toast in
                DoriDoriToastView(text: toast).show()
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$actionSheetAlertController)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, actionSheet in
                let viewController = actionSheet.configure()
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        self.questions
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, questions in
                if owner.textField.isFirstResponder {
                    owner.textField.resignFirstResponder()
                }
                owner.collectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setupLayouts() {
        self.view.addSubview(self.collectionView)
        self.commentView.addSubViews(self.textField, self.registButton)
        self.textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        self.registButton.snp.makeConstraints {
            $0.top.bottom.equalTo(self.textField)
            $0.leading.equalTo(self.textField.snp.trailing).offset(9)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.equalTo(47)
        }
        self.view.addSubview(self.commentView)
        
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.commentView.snp.makeConstraints {
            $0.height.equalTo(59)
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyPageOtherSpeechBubbleCell.self)
        collectionView.register(EmptyCell.self)
        collectionView.refreshControl = self.refreshControl
        self.refreshControl.tintColor = .lime300
    }
}

// MARK: - UICollectionViewDataSource

extension QuestionReceivedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if self.questions.value.isEmpty {
            return 1
        }
        else { return self.questions.value.count }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if self.questions.value.isEmpty {
            let cell = collectionView.dequeueReusableCell(type: EmptyCell.self, for: indexPath)
            cell.configure(title: "질문을 요청해보세요!")
            return cell
        }
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item")
        }
        let cell = collectionView.dequeueReusableCell(type: MyPageOtherSpeechBubbleCell.self, for: indexPath)
        cell.configure(item, shouldHideButtonstackView: false)
        cell.bindAction(
            didTapProfile: self.didTapProfile,
            didTapComment: self.didTapCommentButton,
            didTapDeny: self.didTapDenyButton,
            didTapMoreButton: self.didTapMoreButton,
            at: indexPath
        )
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension QuestionReceivedViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if self.questions.value.isEmpty {
            return collectionView.bounds.size
        }
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item")
        }
        return MyPageOtherSpeechBubbleCell.fittingSize(
            width: collectionView.bounds.width,
            item: item,
            shouldHideButtonstackView: false
        )
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if !self.questions.value.isEmpty {
            self.didSelectCell.accept(indexPath)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if !self.questions.value.isEmpty {
            self.willDisplayCell.accept(indexPath)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension QuestionReceivedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
