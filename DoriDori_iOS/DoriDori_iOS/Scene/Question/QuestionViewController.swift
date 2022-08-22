//
//  QuestionViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import RxGesture
import DropDown

final class QuestionViewController: UIViewController,
                                    View {
    
    // MARK: - UIComponents
    
    private let navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "질문하기"
        label.textColor = UIColor.white
        label.font = UIFont.setKRFont(weight: .regular, size: 18)
        return label
    }()
    
    private let registNavigationButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(UIColor.gray700, for: .normal)
        return button
    }()
    
    private let selectView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray900
        view.layer.borderColor = UIColor.gray800.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let nicknameDropDownView = DropDownView(title: "닉네임")
    private let wardDropDownView = DropDownView(title: "현위치")
    private let dropDownView = DropDown()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.inputAccessoryView = self.registButtonContainerView
        textView.tintColor = .lime300
        textView.font = UIFont.setKRFont(weight: .regular, size: 16)
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .regular, size: 16)
        label.textColor = .gray600
        return label
    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/300"
        label.textColor = .gray600
        label.font = UIFont.setKRFont(weight: .regular, size: 13)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    
    private let registButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let registButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.gray300, for: .normal)
        button.setTitle("질문등록", for: .normal)
        button.backgroundColor = .gray700
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Properties
    
    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    let reactor: QuestionReactor
    let coordinator: QuestionCoordinator
    var disposeBag: DisposeBag
    
    // MARK: - LifeCycles
    
    init(
        reactor: QuestionReactor,
        coordinator: QuestionCoordinator
    ) {
        self.reactor = reactor
        self.coordinator = coordinator
        self.disposeBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.bind(reactor: self.reactor)
        self.bind()
        self.configure(self.dropDownView)
        self.view.backgroundColor = .darkGray
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func bind(reactor: QuestionReactor) {
        
        Observable.merge(
            self.registButton.rx.throttleTap.asObservable(),
            self.registNavigationButton.rx.throttleTap.asObservable()
        )
        .map { _ in return }
        .map { QuestionReactor.Action.didTapRegistQuestion }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
        
        self.textView.rx.text.orEmpty
            .map { QuestionReactor.Action.didEditing(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // MARK: State binding
        
        reactor.pulse(\.$shouldPopViewController)
            .compactMap { $0 }
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.coordinator.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$textCount)
            .bind(with: self) { owner, textCount in
                owner.textCountLabel.text = textCount
            }
            .disposed(by: self.disposeBag)
        
        let canRegistQuestion = reactor.pulse(\.$canRegistQuestion)
            .distinctUntilChanged()
            .do(onNext: { [weak self] canRegist in
                self?.registNavigationButton.isUserInteractionEnabled = canRegist
                self?.registButton.isUserInteractionEnabled = canRegist
            })
            .share()
                
        canRegistQuestion
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.registButton.setTitleColor(.darkGray, for: .normal)
                owner.registButton.backgroundColor = .lime300
                owner.registNavigationButton.setTitleColor(.lime300, for: .normal)
            }
            .disposed(by: self.disposeBag)
        
        canRegistQuestion
            .filter { !$0 }
            .bind(with: self) { owner, _ in
                owner.registButton.setTitleColor(.gray300, for: .normal)
                owner.registButton.backgroundColor = .gray700
                owner.registNavigationButton.setTitleColor(.gray700, for: .normal)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Private functions

extension QuestionViewController {
    
    private func configure(_ dropDown: DropDown) {
        dropDown.cornerRadius = 10
        dropDown.width = 128
        dropDown.textColor = .white
        dropDown.backgroundColor = UIColor.gray800
        dropDown.selectedTextColor = .lime300
        dropDown.selectionBackgroundColor = .gray800
        dropDown.cellHeight = 40
    }
    
    private func bind() {
        self.navigationBackButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                owner.coordinator.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.nicknameDropDownView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.dropDownView.anchorView = owner.nicknameDropDownView
                owner.dropDownView.bottomOffset = CGPoint(x: 0, y: (owner.dropDownView.anchorView?.plainView.bounds.height)!)
                owner.dropDownView.dataSource = ["익명", "닉네임"]
                owner.dropDownView.show()
            }
            .disposed(by: self.disposeBag)
        
        self.wardDropDownView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.dropDownView.anchorView = owner.wardDropDownView
                owner.dropDownView.bottomOffset = CGPoint(x: 0, y: (owner.dropDownView.anchorView?.plainView.bounds.height)!)
                owner.dropDownView.dataSource = ["현위치", "강남구", "서초구", "관악구", "집", "본가", "마음속", "침대속", "도리도리", "도도도리리리"]
                owner.dropDownView.show()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setupLayouts() {
        self.view.addSubViews(
            self.navigationBackButton,
            self.navigationTitle,
            self.registNavigationButton,
            self.selectView,
            self.textView,
            self.textCountLabel,
            self.dividerView,
            self.registButtonContainerView
        )
        self.registButtonContainerView.addSubview(self.registButton)
        self.selectView.addSubViews(self.nicknameDropDownView, self.wardDropDownView)
        
        self.navigationBackButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.size.equalTo(24)
            $0.leading.equalToSuperview().offset(23)
        }
        self.navigationTitle.snp.makeConstraints {
            $0.top.equalTo(self.navigationBackButton.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        self.registNavigationButton.snp.makeConstraints {
            $0.top.equalTo(self.navigationBackButton.snp.top)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        self.selectView.snp.makeConstraints {
            $0.top.equalTo(self.navigationTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        self.textView.snp.makeConstraints {
            $0.top.equalTo(self.selectView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(402)
        }
        self.textCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.textView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(30)
        }
        self.dividerView.snp.makeConstraints {
            $0.top.equalTo(self.textCountLabel.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        self.registButtonContainerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        self.registButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
        
        self.nicknameDropDownView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.bottom.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().offset(30)
        }
        self.wardDropDownView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.nicknameDropDownView)
            $0.leading.equalTo(self.nicknameDropDownView.snp.trailing).offset(20)
        }
    }
}
