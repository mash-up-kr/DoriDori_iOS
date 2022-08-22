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
    private let nicknameDropDown = DropDown()
    private let wardDropDown = DropDown()
    
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
    private let viewDidLoadStream: PublishRelay<Void>
    private let didSelectNicknameItem: PublishRelay<Int>
    private let didSelectWardItem: PublishRelay<Int>
    
    // MARK: - LifeCycles
    
    init(
        reactor: QuestionReactor,
        coordinator: QuestionCoordinator
    ) {
        self.viewDidLoadStream = .init()
        self.reactor = reactor
        self.coordinator = coordinator
        self.disposeBag = .init()
        self.didSelectNicknameItem = .init()
        self.didSelectWardItem = .init()
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
        self.configure(self.nicknameDropDown)
        self.configure(self.wardDropDown)
        self.configureDropDownToggle()
        self.view.backgroundColor = .darkGray
        
        self.viewDidLoadStream.accept(())
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
        
        self.didSelectNicknameItem
            .map { QuestionReactor.Action.didSelectNicknameItem(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
 
        self.didSelectWardItem
            .map { QuestionReactor.Action.didSelectWradItem(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.viewDidLoadStream
            .map { QuestionReactor.Action.viewDidLoad }
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
        
        self.nicknameDropDownView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(reactor.pulse(\.$nicknameDropDownDataSource))
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, dataSource in
                owner.nicknameDropDown.anchorView = owner.nicknameDropDownView
                if let offsetY = owner.nicknameDropDown.anchorView?.plainView.bounds.height {
                    owner.nicknameDropDown.bottomOffset = CGPoint(x: 0, y: offsetY)
                } else { owner.nicknameDropDown.bottomOffset = .zero }
                
                owner.nicknameDropDown.dataSource = dataSource.map { $0.name }
                if let selectedIndex = owner.findSelectedIndex(at: dataSource) {
                    owner.nicknameDropDown.selectRow(selectedIndex)
                }
                owner.nicknameDropDown.show()
            }
            .disposed(by: self.disposeBag)
        
        self.wardDropDownView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(reactor.pulse(\.$myWardDropDownDataSources))
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, dataSource in
                print("🤔 datasource를 클릭했다.", dataSource)
                owner.wardDropDown.anchorView = owner.wardDropDownView
                if let offsetY = owner.wardDropDown.anchorView?.plainView.bounds.height {
                    owner.wardDropDown.bottomOffset = CGPoint(x: 0, y: offsetY)
                } else { owner.wardDropDown.bottomOffset = .zero }
                
                owner.wardDropDown.dataSource = dataSource.map { $0.name }
                if let selectedIndex = owner.findSelectedIndex(at: dataSource) {
                    owner.wardDropDown.selectRow(selectedIndex)
                }
                owner.wardDropDown.show()
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$nicknameDropDownDataSource)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, dataSource in
                dataSource.forEach { item in
                    if item.isSelected {
                        owner.nicknameDropDownView.update(title: item.name)
                        return
                    }
                }
            }
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$myWardDropDownDataSources)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, dataSource in
                dataSource.forEach { item in
                    if item.isSelected {
                        owner.wardDropDownView.update(title: item.name)
                        return
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Private functions

extension QuestionViewController {

    private func findSelectedIndex(at dropdownItems: [DropDownItemType]) -> Int? {
        var selectedIndex: Int?
        dropdownItems.enumerated().forEach { index, item in
            if item.isSelected { selectedIndex = index }
            return
        }
        return selectedIndex
    }
    
    private func configure(_ dropDown: DropDown) {
        dropDown.cornerRadius = 10
        dropDown.width = 128
        dropDown.textColor = .white
        dropDown.backgroundColor = UIColor.gray800
        dropDown.textFont = UIFont.setKRFont(weight: .regular, size: 14) ?? .systemFont(ofSize: 14, weight: .regular)
        dropDown.selectedTextColor = .lime300
        dropDown.selectionBackgroundColor = .gray800
        dropDown.cellHeight = 40
    }
    
    private func configureDropDownToggle() {
        self.wardDropDown.willShowAction = { [weak self] in
            self?.wardDropDownView.shouldChangeToggleImage(isDropDowned: true)
        }
        self.wardDropDown.cancelAction = { [weak self] in
            self?.wardDropDownView.shouldChangeToggleImage(isDropDowned: false)
        }
        self.nicknameDropDown.willShowAction = { [weak self] in
            self?.nicknameDropDownView.shouldChangeToggleImage(isDropDowned: true)
        }
        self.nicknameDropDown.cancelAction = { [weak self] in
            self?.nicknameDropDownView.shouldChangeToggleImage(isDropDowned: false)
        }
    }
    
    private func bind() {
        self.navigationBackButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                owner.coordinator.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.nicknameDropDown.selectionAction = { [weak self] index, _ in
            print("🤔닉네임에서 선택된 인덱스는 \(index)")
            self?.didSelectNicknameItem.accept(index)
            self?.nicknameDropDownView.shouldChangeToggleImage(isDropDowned: false)
        }
        self.wardDropDown.selectionAction = { [weak self] index, _ in
            print("🤔와드에서 선택된 인덱스는 \(index)")
            self?.didSelectWardItem.accept(index)
            self?.wardDropDownView.shouldChangeToggleImage(isDropDowned: false)
        }
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
