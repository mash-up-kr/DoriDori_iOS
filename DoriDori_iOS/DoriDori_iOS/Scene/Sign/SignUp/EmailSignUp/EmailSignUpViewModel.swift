//
//  EmailSignUpViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/20.
//

import RxSwift
import RxRelay

final class EmailSignUpViewModel: ViewModelProtocol {
    
    private let repository: EmailCertificationRepository = .init()
    private let buttonType: BehaviorRelay<ButtonType> = .init(value: .sendEmail)
    
    struct Input {
        let email: Observable<String>
        let authNumber: Observable<String>
        let sendButtonTap: Observable<Void>
    }
    
    struct Output {
        let isValidEmail: Observable<Bool>
        let sendEmail: Observable<Void>
        let finalConfirm: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let buttonisValidOutput = input.email.map { str -> Bool in
            if str.emailValidCheck { return true }
            else { return false }
        }
        
        let sendEmailOutput = input.sendButtonTap.filter { [weak self] _ in
            self?.buttonType.value == .sendEmail
        }.withLatestFrom(input.email)
            .flatMapLatest { [weak self] email -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.repository.requestEmail(email: email)
                    .catch({ error in
                        print(error) // TODO: 서버 에러
                        return .empty()
                    }).map { _ in
                        return
                    }.do(onNext: { [weak self] _ in
                        self?.buttonType.accept(.checkAuthNumber)
                    })}
            .observe(on: MainScheduler.instance)
        
        let confirmOutput = input.sendButtonTap
            .filter { [weak self] _ in
                self?.buttonType.value == .checkAuthNumber
            }.withLatestFrom(Observable.combineLatest(input.email, input.authNumber) { ($0, $1) })
            .flatMapLatest { [weak self] email, authNumber -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.repository.confirmAuthNumber(email: email, authNumber: authNumber)
                    .catch({ error in
                        print(error) // TODO: 서버 에러
                        return .empty()
                    }).map { _ in
                        return
                    }.do(onNext: { [weak self] _ in
                        self?.buttonType.accept(.sendEmail)
                    })}
            .observe(on: MainScheduler.instance)
        
        return Output(isValidEmail: buttonisValidOutput, sendEmail: sendEmailOutput, finalConfirm: confirmOutput)
    }
    
}
