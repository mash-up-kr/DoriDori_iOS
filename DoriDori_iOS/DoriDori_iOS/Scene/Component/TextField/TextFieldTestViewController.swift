//
//  TextFieldTestViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/10.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldTestViewController: UIViewController {

    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailTextField: UnderLineTextField!
    @IBOutlet weak var passwordTextField: UnderLineTextField!

    let disposeBag = DisposeBag()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.data = TextFieldData(type: .email)
        passwordTextField.data = TextFieldData(type: .password)
        emailTextField.rxBind()
        passwordTextField.rxBind()
        validLoginButton()
    }
    
    private func validLoginButton() {
        Observable.combineLatest(emailTextField.boolSubject, passwordTextField.boolSubject, resultSelector: { $0 && $1 })
            .subscribe(onNext: { b in
                self.confirmButton.isEnabled = b
            })
            .disposed(by: disposeBag)
    }
}
