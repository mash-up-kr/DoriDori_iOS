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

final class EmailSignUpViewController: UIViewController, StoryboardView {
    typealias Reactor = EmailSignUpViewModel
    
    enum ButtonType {
        case sendEmail
        case checkAuthNumber
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var sendToAuthNumberButton: UIButton!
    
    private let repository: EmailCertificationRepository = .init()
    private var buttonType: ButtonType = .sendEmail
    var disposeBag = DisposeBag()


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        authNumberTextField.delegate = self
        authNumberTextField.isHidden = true
        sendAuthNumber()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: EmailSignUpViewModel) {
        
    }
    
    // TODO: 인증번호 전송하고 이메일 수정하는 케이스 생각,,
    private func sendAuthNumber() {
        //이메일 전송
        sendEmail(buttonType)
        //인증번호 체크
        sendToAuthNumberButton.rx.tap.filter { [weak self] _ in
            self?.buttonType == .checkAuthNumber
        }.withLatestFrom(Observable.combineLatest(emailTextField.rx.text.orEmpty, authNumberTextField.rx.text.orEmpty) { ($0, $1) })
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
        }.withLatestFrom(emailTextField.rx.text.orEmpty)
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

extension EmailSignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textFieldText = textField.text else { return }
        print(textFieldText)
        sendToAuthNumberButton.backgroundColor = UIColor(named: "lime300")
        if textField == authNumberTextField {
            self.sendToAuthNumberButton.setTitle("확인", for: .normal)
        }
//        if textFieldText.isEmpty  {
//            sendToAuthNumberButton.isUserInteractionEnabled = false
//            // TODO: 버튼 색상 변경
//
//        } else {
//            sendToAuthNumberButton.isUserInteractionEnabled = true
//
//        }
    }
}
