//
//  QuestionReceivedViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/04.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxRelay

final class QuestionReceivedViewController: UIViewController,
                                            View {
    
    // MARK: - UIComponents
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .darkGray
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private let commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray900
        return view
    }()
    
    private let registButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 12)
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor.lime300, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lime300.cgColor
        return button
    }()
    
    private let fakeTexTifled = UITextField()
    
    private lazy var commentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
//        textField.inputAccessoryView = self.commentView
        textField.tintColor = UIColor.lime300
        return textField
    }()
    
    // MARK: - Properties
    
    var reactor: QuestionReceivedReactor
    var disposeBag: DisposeBag
    private let viewDidLoadStream: PublishRelay<Void>
    private let questions: BehaviorRelay<[MyPageOtherSpeechBubbleItemType]>
    private let didTapMoreButton: PublishRelay<Int>
    private let didTapCommentButton: PublishRelay<Int>
    private let didTapRefuseButton: PublishRelay<Int>
    
    // MARK: - LifeCycels
    
    init(
        questionReceivedReactor: QuestionReceivedReactor
    ) {
        self.didTapMoreButton = .init()
        self.didTapCommentButton = .init()
        self.didTapRefuseButton = .init()
        self.reactor = questionReceivedReactor
        self.disposeBag = .init()
        self.viewDidLoadStream = .init()
        self.questions = .init(value: [])
        
        super.init(nibName: nil, bundle: nil)
        fakeTexTifled.inputAccessoryView = self.commentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.configure(self.collectionView)
        self.bind()
        self.bind(reactor: self.reactor)
        
        self.viewDidLoadStream.accept(())
    }
    
    func bind(reactor: QuestionReceivedReactor) {
        self.bind(action: reactor.action)
        self.bind(state: reactor.state)
    }
}

// MARK: - Private functions

extension QuestionReceivedViewController {
    
    private func bind(action: ActionSubject<QuestionReceivedReactor.Action>) {
        self.viewDidLoadStream
            .map { QuestionReceivedReactor.Action.viewDidLoad }
            .bind(to: action)
            .disposed(by: self.disposeBag)
    }
    
    private func bind(state: Observable<QuestionReceivedReactor.State>) {
        state.map(\.questions)
            .bind(to: self.questions)
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {

        
//
//        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
//            .compactMap { noti -> CGFloat? in
//                guard let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
//                      let keyboardRectangle = keyboardFrame.cgRectValue
//                      return keyboardRectangle.height
//            }
//            .bind(with: self) { owner, height in
//                print("height", height)
//                owner.commentView.isHidden = false
//                owner.commentView.snp.remakeConstraints { make in
//                    make.bottom.equalToSuperview().inset(height)
//                    make.height.equalTo(58)
//                    make.leading.trailing.equalToSuperview()
//                }
//            }
//            .disposed(by: self.disposeBag)
//
//        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
//            .bind(with: self) { owner, _ in
//                owner.commentView.isHidden = true
//                owner.commentView.snp.updateConstraints { make in
//                    make.bottom.equalToSuperview().inset(0)
//                }
//            }
//            .disposed(by: self.disposeBag)
        
        self.questions
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
        
        self.didTapMoreButton
            .map { index -> UIAlertController in
                let reportAction = ActionSheetAction(title: "신고하기") { _ in
                    print("\(index) 번 째에 신고하기가 눌렸다!")
                }
                let alertController = ActionSheetAlertController(actionModels: reportAction).configure()
                return alertController
            }
            .bind(with: self) { owner, alertcontroller in
                owner.present(alertcontroller, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.didTapCommentButton
            .bind(with: self) { owner, index in
                print(index, "번 째 답변하기가 눌렸다!")
//                owner.commentView.isHidden = false
//                owner.commentTextField.becomeFirstResponder()
//                owner.fakeTexTifled.becomeFirstResponder()
//                print(owner.commentView.frame)
//                print(owner.commentView)
            }
            .disposed(by: self.disposeBag)
        
        self.commentTextField.rx.text.orEmpty
            .filter { $0.isEmpty }
            .bind(with: self, onNext: { owner, text in
                // TODO: toast를 띄워야합니다.
            })
            .disposed(by: self.disposeBag)
        
        self.fakeTexTifled.rx.text.orEmpty
            .bind(to: self.commentTextField.rx.text).disposed(by: self.disposeBag)
        
        self.commentTextField.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, text in
                print(owner.commentView)
            }
            .disposed(by: self.disposeBag)
        
        self.didTapRefuseButton
            .bind(with: self) { owner, index in
                print("\(index) 번 째 거절하기가 눌렸다!")
            }
            .disposed(by: self.disposeBag)
        
        self.registButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                owner.fakeTexTifled.resignFirstResponder()
//                owner.commentView.isHidden = true
            }
            .disposed(by: self.disposeBag)

    }
    
    private func setupLayouts() {
        self.commentTextField.addSubview(self.fakeTexTifled)
        self.fakeTexTifled.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.commentView.addSubViews(self.commentTextField, self.registButton)
        self.commentTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        self.registButton.snp.makeConstraints {
            $0.centerY.equalTo(self.commentTextField.snp.centerY)
            $0.width.equalTo(47)
            $0.height.equalTo(30)
            $0.leading.equalTo(self.commentTextField.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(30)
        }
        self.view.addSubViews(self.collectionView, self.commentView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.commentView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(58)
        }
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.register(MyPageOtherSpeechBubbleCell.self)
        collectionView.register(HomeOtherSpeechBubbleCell.self)
    
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension QuestionReceivedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.questions.value.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item") }
        let cell = collectionView.dequeueReusableCell(type: MyPageOtherSpeechBubbleCell.self, for: indexPath)
        
        cell.didTapMoreButton = { [weak self] in
            self?.didTapMoreButton.accept(indexPath.item)
        }
        cell.keyInputView = self.commentView
        cell.didTapCommentButton = { [weak self] in
            self?.didTapCommentButton.accept(indexPath.item)
        }
        
        cell.didTapRefuseButton = { [weak self] in
            self?.didTapRefuseButton.accept(indexPath.item)
        }
        cell.configure(item)
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
        guard let item = self.questions.value[safe: indexPath.item] else { fatalError("can not find item") }
        let size = MyPageOtherSpeechBubbleCell.fittingSize(
            width: collectionView.bounds.width,
            item: item
        )
        return size
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension QuestionReceivedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}
