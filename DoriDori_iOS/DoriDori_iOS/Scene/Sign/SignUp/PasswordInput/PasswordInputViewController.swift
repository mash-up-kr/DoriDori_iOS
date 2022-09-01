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
    @IBOutlet private weak var confirmButtonButtomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationBackButton: UIButton!
    
    private let viewModel: PasswordViewModel = .init()
    var email: String = ""
    var termsIds: [String] = []
    private var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
        bind(viewModel)
        keyboardSetting()
        settingNavigation()
    }

    private func settingNavigation() {
        self.navigationController?.navigationBar.isHidden = true
        let navi = navigationBackButton.rx.tap.asObservable()
        navi.bind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
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
                                            termsIds: Observable.just(termsIds),
                                            email: Observable.just(email),
                                            confirmTap: confirmButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        passwordTextField.textField.rx.controlEvent(.editingChanged)
            .withLatestFrom(output.pwIsValid)
            .filter { $0 }
            .bind { [weak self] _ in
                guard let self = self?.passwordTextField else { return }
                self.errorLabel.text = "비밀번호로 사용이 가능해요."
                self.errorLabel.textColor = UIColor(named: "lime300")
            }.disposed(by: disposeBag)
        
        passwordTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(output.pwIsValid)
            .bind { [weak self] isValid in
                guard let self = self?.passwordTextField else { return }
                if !isValid {
                    self.errorLabel.text = "비밀번호를 확인해주세요."
                    self.errorLabel.textColor = UIColor(named: "red500")
                    self.underLineView.backgroundColor = UIColor(named: "red500")
                    self.iconImageView.image = UIImage(named: "error")
                } else {
                    self.iconImageView.image = UIImage(named: "check_circle")
                    self.errorLabel.text = ""
                }
            }.disposed(by: disposeBag)
        
        
        output.pwConfirmIsValid.bind { [weak self] isValid in
            self?.confirmButton.isEnabled = isValid
            self?.confirmButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.confirmButton.setTitleColor(buttonTitleColor, for: .normal)
        }.disposed(by: disposeBag)
        
        passwordConfirmTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(output.pwConfirmIsValid)
            .filter { !$0 }
            .bind { [weak self] isValid in
                self?.passwordConfirmTextField.errorLabel.text = "비밀번호를 확인해주세요."
                self?.passwordConfirmTextField.errorLabel.textColor = UIColor(named: "red500")
                self?.passwordConfirmTextField.underLineView.backgroundColor = UIColor(named: "red500")
                self?.passwordConfirmTextField.iconImageView.image = UIImage(named: "error")
            }.disposed(by: disposeBag)
        
        output.signUpOutput.bind { [weak self] tokenData in
            UserDefaults.accessToken = tokenData.accessToken
            UserDefaults.refreshToken = tokenData.refreshToken
            UserDefaults.userID = tokenData.userId
            print("회원가입 성공!! \(tokenData)")
            self?.passwordConfirmTextField.textField.resignFirstResponder()
            let stroyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let vc = stroyboard.instantiateViewController(withIdentifier: "NicknameSettingViewController") as? NicknameSettingViewController else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
}

extension PasswordViewController {
    func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let keyboardButtonSpace: Int = 10
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmButtonButtomConstraint.constant = CGFloat(keyboardButtonSpace) + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let buttonButtomConstraintSize: Int = 54
        UIView.animate(withDuration: 0.3) {
            self.confirmButtonButtomConstraint.constant = CGFloat(buttonButtomConstraintSize)
            self.view.layoutIfNeeded()
        }
        
    }
}

