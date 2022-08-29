//
//  EmailLoginViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/09.
//

import UIKit
import RxSwift

final class EmailSignInViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UnderLineTextField!
    @IBOutlet private weak var passwordTextField: UnderLineTextField!
    
    //하단
    @IBOutlet private weak var emailPwFindStackView: UIStackView!
    @IBOutlet private weak var emailSignUpButton: UIButton!
    @IBOutlet private weak var emailFindButton: UIButton!
    @IBOutlet private weak var passwordFindButton: UIButton!
    @IBOutlet private weak var loginButtomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let keyboardUpButtomConstraint: CGFloat = 20
    private let keyboardDownButtomConstraint: CGFloat = 54

    private let viewModel: EmailSignInViewModel = .init()
    private var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSetting()
        settingViewModel()
        bind(viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "입장하기"
        navigationController?.navigationBar.topItem?.title = ""
    }

    // MARK: - Bind ViewModel
    private func settingViewModel() {
        emailTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .email,
                                                               inputContentType: .emailAddress,
                                                               returnKeyType: .default,
                                                               keyboardType: .emailAddress)
        passwordTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .password,
                                                                    inputContentType: .password,
                                                                    returnKeyType: .default,
                                                                    keyboardType: .default)
    }
    
    private func bind(_ viewModel: EmailSignInViewModel) {
        guard let email = emailTextField.textField else { return }
        guard let password = passwordTextField.textField else { return }
        
        
        let input = EmailSignInViewModel.Input(email: email.rx.text.orEmpty.asObservable(),
                                               password: password.rx.text.orEmpty.asObservable(),
                                               loginButtonTap: loginButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        email.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(output.emailIsValid)
            .filter { !$0 }
            .bind { [weak self] _ in
                guard let self = self?.emailTextField else { return }
                self.errorLabel.text = "이메일 주소를 확인해주세요."
                self.underLineView.backgroundColor = UIColor(named: "red500")
                self.iconImageView.image = UIImage(named: "error")
            }.disposed(by: disposeBag)
        
        password.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(output.passwordIsValid)
            .filter { !$0 }
            .bind { [weak self] _ in
                guard let self = self?.passwordTextField else { return }
                self.errorLabel.text = "비밀번호를 확인해주세요."
                self.underLineView.backgroundColor = UIColor(named: "red500")
                self.iconImageView.image = UIImage(named: "error")
            }.disposed(by: disposeBag)
       
        
        output.buttonIsValid.bind { [weak self] isValid in
            self?.loginButton.isEnabled = isValid
            self?.loginButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.loginButton.setTitleColor(buttonTitleColor, for: .normal)
        }.disposed(by: disposeBag)
        
        output.signIn.bind { [weak self]_ in
            self?.navigationController?.pushViewController(HomeViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        output.errorMessage.emit(onNext: { [weak self] str in
            let alert = UIAlertController(title: "로그인", message: str, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirmAction)
            self?.present(alert, animated: true)
        }).disposed(by: disposeBag)

    }
}

//MARK: - textField 편집시 Keyboard 설정
extension EmailSignInViewController {
    func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.loginButtomConstraint.constant = 28 + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.loginButtomConstraint.constant = 54
            self.view.layoutIfNeeded()
        }
       
    }

}
