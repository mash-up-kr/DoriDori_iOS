//
//  EmailSignUpViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class EmailSignUpViewController: UIViewController {
    typealias Reactor = EmailSignUpViewModel
    
    enum ButtonType {
        case sendEmail
        case checkAuthNumber
    }
    
    @IBOutlet weak var emailTextField: UnderLineTextField!
    @IBOutlet weak var authNumberTextField: UnderLineTextField!
    @IBOutlet weak var sendToAuthNumberButton: UIButton!
    
    private let repository: EmailCertificationRepository = .init()
    private var buttonType: ButtonType = .sendEmail
    var disposeBag = DisposeBag()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authNumberTextField.isHidden = true
        settingViewModel()
        sendAuthNumber()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    // MARK: - func()
    
    private func settingViewModel() {
        emailTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .email,
                                                               inputContentType: .emailAddress,
                                                               returnKeyType: .continue,
                                                               keyboardType: .emailAddress)
        authNumberTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .authNumber,
                                                                    inputContentType: .oneTimeCode,
                                                                    returnKeyType: .done,
                                                                    keyboardType: .numberPad)
    }
    
    // TODO: 인증번호 전송하고 이메일 수정하는 케이스 생각,,
    private func sendAuthNumber() {
        //이메일 전송
        sendEmail(buttonType)
        //인증번호 체크
        sendToAuthNumberButton.rx.tap.filter { [weak self] _ in
            self?.buttonType == .checkAuthNumber
        }.withLatestFrom(Observable.combineLatest(emailTextField.textField.rx.text.orEmpty, authNumberTextField.textField.rx.text.orEmpty) { ($0, $1) })
            .flatMapLatest { [weak self] email, authNumber -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.repository.confirmAuthNumber(email: email, authNumber: authNumber)
                    .catch({ error in
                        print(error) // TODO: 서버 에러
                        return .empty()
                    }).map { _ in
                        return
                    }
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.sendToAuthNumberButton.backgroundColor = UIColor(named: "lime300")
                print("인증성공")
            }).disposed(by: disposeBag)
    }
    
    // TODO: 이메일 재전송 버튼 누를 때
    private func sendEmail(_ type: ButtonType) {
        sendToAuthNumberButton.rx.tap.filter { [weak self] _ in
            self?.buttonType == .sendEmail
        }.withLatestFrom(emailTextField.textField.rx.text.orEmpty)
            .flatMapLatest { [weak self] email -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.repository.requestEmail(email: email)
                    .catch({ error in
                        print(error) // TODO: 서버 에러
                        return .empty()
                    }).map { _ in
                        return
                    }
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.authNumberTextField.isHidden = false
                self?.sendToAuthNumberButton.isEnabled = true
                self?.sendToAuthNumberButton.backgroundColor = UIColor(named: "gray700")
                self?.buttonType = .checkAuthNumber
                print("이메일 전송")
            }).disposed(by: self.disposeBag)
    }
    
    
    //        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordInputViewController") as? PasswordInputViewController
    //        else { return }
    //        navigationController?.pushViewController(vc, animated: true)
    
    
}
