//
//  EmailSignInViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa

final class EmailSignInViewModel: ViewModelProtocol {
    
    private let repository: EmailSignInRepository = .init()
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let loginButtonTap: Observable<Void>
    }
    
    struct Output {
        let buttonIsValid: Observable<Bool>
        let emailIsValid: Observable<Bool>
        let passwordIsValid: Observable<Bool>
        let signIn: Observable<Void>
        let errorMessage: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        
        let emailIsValid = input.email.filter { !$0.isEmpty }
            .map { email -> Bool in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                return predicate.evaluate(with: email)
            }
        
        let passwordIsValid = input.password.filter { !$0.isEmpty }
            .map { pw -> Bool in
                let passwordreg = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,20}"
                let predicate = NSPredicate(format: "SELF MATCHES %@", passwordreg)
                return predicate.evaluate(with: pw)
            }
        
           
        let buttonIsValid = Observable.combineLatest(emailIsValid, passwordIsValid) { $0 && $1 }
        
        let errorRelay = PublishRelay<String>()
        let signIn = input.loginButtonTap.withLatestFrom(Observable.combineLatest(input.email, input.password) { ($0, $1) })
            .flatMapLatest { [weak self] email, password -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.repository.requestLogin(email: email, loginType: "BASIC", password: password)
                    .catch { error in
                        guard let errorModel = error.toErrorModel else { return .empty() }
                        if errorModel.code == "LOGIN_FAILED" {
                            guard let errorMsg = errorModel.message else {
                                return .empty()
                            }
                            errorRelay.accept(errorMsg)
                        }
                        return .empty()
                    }.map({ _ in
                        return
                    })}.observe(on: MainScheduler.instance)
                
        return Output(buttonIsValid: buttonIsValid, emailIsValid: emailIsValid, passwordIsValid: passwordIsValid, signIn: signIn, errorMessage: errorRelay.asSignal())
    }

}
