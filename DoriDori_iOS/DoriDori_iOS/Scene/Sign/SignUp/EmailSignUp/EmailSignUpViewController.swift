//
//  EmailSignUpViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa

enum ButtonType {
    case sendEmail
    case checkAuthNumber
}

final class EmailSignUpViewController: UIViewController {
    
    typealias Reactor = EmailSignUpViewModel
    
    @IBOutlet private weak var emailTextField: UnderLineTextField!
    @IBOutlet private weak var authNumberTextField: UnderLineTextField!
    @IBOutlet private weak var sendToAuthNumberButton: UIButton!
    @IBOutlet private weak var sendButtonButtomConstraint: NSLayoutConstraint!
    
    private let viewModel: EmailSignUpViewModel = .init()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authNumberTextField.isHidden = true
        settingViewModel()
        keyboardSetting()
        bind(viewModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    // MARK: - Bind
    private func settingViewModel() {
        emailTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .email,
                                                               inputContentType: .emailAddress,
                                                               returnKeyType: .default,
                                                               keyboardType: .emailAddress)
        authNumberTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .authNumber,
                                                                    inputContentType: .oneTimeCode,
                                                                    returnKeyType: .default,
                                                                    keyboardType: .numberPad)
    }
    
    private func bind(_ viewModel: EmailSignUpViewModel) {
        let input = EmailSignUpViewModel.Input(email: emailTextField.textField.rx.text.orEmpty.asObservable(),
                                               authNumber: authNumberTextField.textField.rx.text.orEmpty.asObservable(),
                                               sendButtonTap: sendToAuthNumberButton.rx.tap.asObservable(),
                                               authNumberResendButton: authNumberTextField.authNumberResendButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
                
        output.isValidEmail.bind { [weak self] isValid in
            self?.buttonValid(isValid)
        }.disposed(by: disposeBag)
        
        output.inputAuthNumber.bind { [weak self] isValid in
            self?.buttonValid(isValid)
        }.disposed(by: disposeBag)
        
        output.sendEmail.bind(onNext: { [weak self] _ in
            self?.authNumberTextField.isHidden = false
            self?.sendToAuthNumberButton.isEnabled = true
            self?.sendToAuthNumberButton.setTitle("확인", for: .normal)
            self?.sendToAuthNumberButton.backgroundColor = UIColor(named: "gray700")
            self?.emailTextField.textField.isEnabled = false
            self?.emailTextField.iconImageView.isHidden = false
            self?.emailTextField.underLineView.backgroundColor = UIColor(named: "gray700")
            self?.emailTextField.iconImageView.image = UIImage(named: "check_circle")
        }).disposed(by: self.disposeBag)
        
        output.finalConfirm.bind(onNext: { [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PasswordInputViewController") as? PasswordInputViewController else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        output.errorMessage.emit(onNext: { [weak self] str in
            self?.authNumberTextField.errorLabel.isHidden = false
            self?.authNumberTextField.errorLabel.text = str
            self?.authNumberTextField.underLineView.backgroundColor = UIColor(named: "red500")
        }).disposed(by: disposeBag)
                
    }
    
    private func buttonValid(_ isValid: Bool) {
        self.sendToAuthNumberButton.isEnabled = isValid
        self.sendToAuthNumberButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
        self.sendToAuthNumberButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
    }
    
}


extension EmailSignUpViewController {
    func keyboardSetting() {
        emailTextField.textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ sender: Notification) {
        let keyboardButtonSpace: Int = 20
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.sendButtonButtomConstraint.constant = CGFloat(keyboardButtonSpace) + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let buttonButtomConstraintSize: Int = 54
        UIView.animate(withDuration: 0.3) {
            self.sendButtonButtomConstraint.constant = CGFloat(buttonButtomConstraintSize)
            self.view.layoutIfNeeded()
        }
        
    }
}
