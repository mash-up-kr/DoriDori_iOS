//
//  ProfileKeywordViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit
import RxSwift
import RxCocoa


final class ProfileKeywordSettingViewController: UIViewController {
    
    @IBOutlet private weak var keywordStackView: UIStackView!
    @IBOutlet private weak var keywordTextField: UnderLineTextField!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var keywordEditButton: UIButton!
    @IBOutlet private weak var keywordCountLabel: UILabel!
    @IBOutlet private weak var startButtomBottomConstraint: NSLayoutConstraint!
    
    private let keywordLimit: Int = 3
    private let keyboardUpButtomConstraint: CGFloat = 20
    private let keyboardDownButtomConstraint: CGFloat = 54
    private let keywordCount: BehaviorRelay<Int> = .init(value: 1)
    private let buttonIsEnable: BehaviorRelay<Bool> = .init(value: false)
    
    private let viewModel: ProfileKeywordSettingViewModel = .init()
    private var disposeBag = DisposeBag()
    var profileIntro: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSetting()
        settingViewModel()
        bind(viewModel)
        keywordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "입장하기"
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func settingViewModel() {
        keywordTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .profileKeyword,
                                                                 keyboardType: .default)
    }
    
    private func bind(_ viewModel: ProfileKeywordSettingViewModel) {
        let output = viewModel.transform(input: ProfileKeywordSettingViewModel.Input(
            editTap: keywordEditButton.rx.tap.asObservable(),
            startTap: startButton.rx.tap.asObservable(),
            description: Observable.just(profileIntro))
        )
        
        output.editState.drive(onNext: { [weak self] state in
            self?.keywordStackView.arrangedSubviews.forEach {
                guard let view = $0 as? ProfileKeywordView else { return }
                view.removeButton.isHidden = state
            }
            let title = state ? "편집" : "편집 취소"
            self?.keywordEditButton.setTitle(title, for: .normal)
        }).disposed(by: disposeBag)
        
        keywordCount.asDriver().drive(onNext: { [weak self] count in
            self?.keywordCountLabel.text = String(count - 1)
        }).disposed(by: disposeBag)
        
        buttonIsEnable.asDriver().drive(onNext: { [weak self] isValid in
            self?.startButton.isEnabled = isValid
            self?.startButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.startButton.setTitleColor(buttonTitleColor, for: .normal)
        }).disposed(by: disposeBag)
        
        
        startButton.rx.tap.bind { [weak self] _ in
            var tags: [String] = []
            self?.keywordStackView.arrangedSubviews.forEach { view in
                guard let keyword = view as? ProfileKeywordView else { return }
                tags.append(keyword.tagName)
            }
            viewModel.tags.accept(tags)
        }.disposed(by: disposeBag)
        
        output.errorMsg.emit(onNext: {  str in
            // TODO: 프로필 설정시 발생되는 에러 팝업 구현
            print("에러 발생", str)
        }).disposed(by: disposeBag)
        
        output.profileOutput.drive(onNext: { [weak self] _ in
            // TODO: 위치정보 허락 여부
            self?.navigationController?.pushViewController(HomeViewController(), animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    private func removeButtonisEnable(_ state: Bool) {
        keywordStackView.arrangedSubviews.forEach {
            guard let view = $0 as? ProfileKeywordView else { return }
            view.removeButton.isHidden = state
        }
    }
    
}


extension ProfileKeywordSettingViewController: ProfileKeywordViewDelegate {
    func removeKeyword(_ view: ProfileKeywordView) {
        if keywordCount.value == keywordLimit {
            buttonIsEnable.accept(true)
        } else {
            buttonIsEnable.accept(false)
        }
        self.keywordStackView.removeArrangedSubview(view)
        view.removeFromSuperview()
        keywordCount.accept(keywordStackView.arrangedSubviews.count)
        UIView.animate(withDuration: 0.2, animations: {
            self.keywordStackView.layoutIfNeeded()
        })
        DoriDoriToastView.init(text: "관심분야가 삭제되었습니다.", duration: 2.0).show()
    }
}

extension ProfileKeywordSettingViewController: UnderLineTextFieldDelegate {
    func addKeyword(_ keyword: String) {
        if keywordCount.value == keywordLimit {
            buttonIsEnable.accept(true)
        } else {
            buttonIsEnable.accept(false)
        }
        if keywordStackView.arrangedSubviews.count <= keywordLimit {
            let keywordView = ProfileKeywordView()
            keywordView.configure(title: keyword)
            self.keywordStackView.addArrangedSubview(keywordView)
            keywordView.delegate = self
            keywordCount.accept(keywordStackView.arrangedSubviews.count)
        }
    }
}

//MARK: - textField 편집시 Keyboard 설정
extension ProfileKeywordSettingViewController {
    private func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.startButtomBottomConstraint.constant = self.keyboardUpButtomConstraint + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.startButtomBottomConstraint.constant = self.keyboardDownButtomConstraint
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
