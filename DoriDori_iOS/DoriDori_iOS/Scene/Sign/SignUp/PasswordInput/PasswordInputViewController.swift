//
//  PasswordInputViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/30.
//

import UIKit
import RxSwift

final class PasswordViewController: UIViewController {
    
    @IBOutlet private weak var passwordTextField: UnderLineTextField!
    @IBOutlet private weak var passwordConfirmTextField: UnderLineTextField!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private let viewModel: PasswordViewModel = .init()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
        bind(viewModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    // MARK: - Bind
    private func settingViewModel() {
        passwordTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .password,
                                                               inputContentType: .password,
                                                               keyboardType: .default)
        passwordConfirmTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .passwordConfirm,
                                                                    inputContentType: .password,
                                                                    keyboardType: .default)
    }
    
    private func bind(_ viewModel: PasswordViewModel) {
        let input = PasswordViewModel.Input(password: passwordTextField.textField.rx.text.orEmpty.asObservable(),
                                            passwordConfirm: passwordConfirmTextField.textField.rx.text.orEmpty.asObservable(),
                                            confirmButtonTap: confirmButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.pwConfirmState.bind { [weak self] isValid in
            print(isValid)
            self?.confirmButton.isEnabled = isValid
            self?.confirmButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.confirmButton.setTitleColor(buttonTitleColor, for: .normal)
        }.disposed(by: disposeBag)
        
        // TODO: 비밀번호 확인 bind 처리 할 것

    }

    
}
