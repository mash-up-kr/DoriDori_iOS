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
    @IBOutlet private weak var loginBUtton: UIButton!
    
    private let keyboardUpButtomConstraint: CGFloat = 20
    private let keyboardDownButtomConstraint: CGFloat = 54

    var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: EmailSignInViewModel) {

    }
    
    @IBAction func tapLoginButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfServiceViewContoller") as? TermsOfServiceViewContoller
        else { return }
        navigationController?.pushViewController(vc, animated: true)
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
                self.emailPwFindStackView.isHidden = true
                self.loginButtomConstraint.constant = 28 + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.emailPwFindStackView.isHidden = false
            self.loginButtomConstraint.constant = 54
            self.view.layoutIfNeeded()
        }
       
    }

}
