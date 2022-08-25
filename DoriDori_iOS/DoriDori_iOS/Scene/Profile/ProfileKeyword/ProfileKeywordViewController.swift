//
//  ProfileKeywordViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileKeywordViewController: UIViewController {
        
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
    
    private let viewModel: ProfileKeywordViewModel = .init()
    private var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignUpNavigationBar()
        keyboardSetting()
        settingViewModel()
        bind(viewModel)
        keywordTextField.delegate = self
    }
    
    private func settingViewModel() {
        keywordTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .profileKeyword,
                                                                 keyboardType: .default)
    }
    
    private func bind(_ viewModel: ProfileKeywordViewModel) {
        let output = viewModel.transform(input: ProfileKeywordViewModel.Input(editTap: keywordEditButton.rx.tap.asObservable()))
        
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
    }
    
    private func removeButtonisEnable(_ state: Bool) {
        keywordStackView.arrangedSubviews.forEach {
            guard let view = $0 as? ProfileKeywordView else { return }
            view.removeButton.isHidden = state
        }
    }
}


extension ProfileKeywordViewController: ProfileKeywordViewDelegate {
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
    }
}

extension ProfileKeywordViewController: UnderLineTextFieldDelegate {
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
extension ProfileKeywordViewController {
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
