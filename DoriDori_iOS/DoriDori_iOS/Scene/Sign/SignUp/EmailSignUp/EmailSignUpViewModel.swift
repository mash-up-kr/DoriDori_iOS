//
//  EmailSignUpViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/20.
//

import RxSwift
import RxCocoa
import Foundation

final class EmailSignUpViewModel: ViewModelProtocol {
    
    private let repository: SignUpRepository = .init()
    private let buttonType: BehaviorRelay<ButtonType> = .init(value: .sendEmail)
    private var disposeBag = DisposeBag()
    
    enum SignUpError: String {
        case duplicate = "DUPLICATED_USER"
        case certFailed = "CERTIFICATE_FAILED"
    }
        
    struct Input {
        let email: Observable<String>
        let authNumber: Observable<String>
        let sendButtonTap: Observable<Void>
        let authNumberResendButton: Observable<Void>
    }
    
    struct Output {
        let isValidEmail: Observable<Bool>
        let inputAuthNumber: Observable<Bool>
        let sendEmailTap: Observable<Void>
        let sendEmailOutput: Observable<Void>
        let finalConfirm: Observable<Void>
        let authErrorMsg: Signal<String>
        let emailErrorMsg: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let buttonisValidOutput = input.email.map { str -> Bool in
            str.emailValidCheck
        }
        
        let inputAuthNumberOutput = input.authNumber.map { str -> Bool in
            str.authNumberCheck
        }
        
        let sendEmailTap = input.sendButtonTap.filter { [weak self] _ in
            self?.buttonType.value == .sendEmail
        }
        
        let timer = Observable.combineLatest(Observable.just(180), Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)) { ($0, $1) }
            .map { start, mil -> String in
                let time = start - mil
                let minute = time / 60
                let second = time % 60
                return NSString(format: "%02d:%02d", minute, second ) as String
            }
    
        // 이메일 전송
        let emailErrorRelay = PublishRelay<String>()
        let sendEmailOutput = Observable.of(input.authNumberResendButton, sendEmailTap)
            .merge()
            .withLatestFrom(input.email)
            .flatMapLatest { [weak self] email -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.repository.requestEmailSend(email: email)
                    .catch({ error in
                        guard let errorModel = error.toErrorModel else { return .empty() }
                        if errorModel.code == SignUpError.duplicate.rawValue {
                            guard let errorMsg = errorModel.message else {
                                return .empty()
                            }
                            emailErrorRelay.accept(errorMsg)
                        }
                        return .empty()
                    }).map { _ in
                        return
                    }.do(onNext: { [weak self] _ in
                        self?.buttonType.accept(.checkAuthNumber)
                    })}
            .observe(on: MainScheduler.instance)
//            .flatMap { timer }
        
        let authErrorRelay = PublishRelay<String>()
        let confirmOutput = input.sendButtonTap
            .filter { [weak self] _ in
                self?.buttonType.value == .checkAuthNumber
            }.withLatestFrom(Observable.combineLatest(input.email, input.authNumber) { ($0, $1) })
            .flatMapLatest { [weak self] email, authNumber -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.repository.confirmAuthNumber(email: email, authNumber: authNumber)
                    .catch({ error in
                        guard let errorModel = error.toErrorModel else { return .empty() }
                        if errorModel.code == SignUpError.certFailed.rawValue {
                            guard let errorMsg = errorModel.message else {
                                return .empty()
                            }
                            authErrorRelay.accept(errorMsg)
                        }
                        return .empty()
                    }).map { _ in
                        return
                    }.do(onNext: { [weak self] _ in
                        self?.buttonType.accept(.sendEmail)
                    })}
            .observe(on: MainScheduler.instance)
        
        return Output(isValidEmail: buttonisValidOutput,
                      inputAuthNumber: inputAuthNumberOutput,
                      sendEmailTap: sendEmailTap,
                      sendEmailOutput: sendEmailOutput,
                      finalConfirm: confirmOutput,
                      authErrorMsg: authErrorRelay.asSignal(),
                      emailErrorMsg: emailErrorRelay.asSignal())
    }

    
}
