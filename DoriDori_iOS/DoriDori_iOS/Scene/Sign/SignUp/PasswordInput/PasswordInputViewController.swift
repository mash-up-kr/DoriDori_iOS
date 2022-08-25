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
        
        output.finalConfirm.bind { [weak self] isValid in
            self?.confirmButton.isEnabled = isValid
            self?.confirmButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.confirmButton.setTitleColor(buttonTitleColor, for: .normal)
            
            //비밀번호 확인 에러 처리
            self?.passwordConfirmTextField.errorLabel.isHidden = isValid
            self?.passwordConfirmTextField.underLineView.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "red500")
            self?.passwordConfirmTextField.textField.tintColor = isValid ? UIColor(named: "lime300") : UIColor(named: "red500")
            self?.passwordConfirmTextField.iconImageView.image = isValid ? UIImage(named: "check_circle") : UIImage(named: "error")
        }.disposed(by: disposeBag)
        
        output.passwordIsValid.bind { [weak self] isValid in
            self?.passwordConfirmTextField.iconImageView.image = isValid ? UIImage(named: "check_circle") : UIImage()
        }.disposed(by: disposeBag)
        
        confirmButton.rx.tap.bind { [weak self] _ in
            let stroyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let vc = stroyboard.instantiateViewController(withIdentifier: "NicknameSettingViewController") as? NicknameSettingViewController else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    
}
