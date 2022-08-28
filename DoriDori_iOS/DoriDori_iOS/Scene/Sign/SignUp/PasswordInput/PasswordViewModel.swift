//
//  PasswordViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/30.
//

import RxSwift
import RxCocoa

final class PasswordViewModel: ViewModelProtocol {

    private let repository: SignUpRepository = .init()
    private var disposeBag = DisposeBag()

    struct Input {
        let password: Observable<String>
        let passwordConfirm: Observable<String>
        let termsIds: Observable<[String]>
        let email: Observable<String>
        let confirmTap: Observable<Void>
    }
    
    struct Output {
        let pwIsValid: Observable<Bool>
        let pwConfirmIsValid: Observable<Bool>
        let signUpOutput: Observable<TokenData>
    }
    
    func transform(input: Input) -> Output {
        
        let pwValid = input.passwordConfirm.map {
            $0.passwordValidCheck
        }
        
        let pwConfirmValid = Observable.combineLatest(input.password.filter { !$0.isEmpty }, input.passwordConfirm.filter { !$0.isEmpty }) { p1, p2 in
            p1 == p2 && p1.passwordValidCheck
        }
        
        let signUpOutput = input.confirmTap.withLatestFrom(Observable.combineLatest(input.termsIds, input.email, input.password) { ($0, $1, $2) })
            .flatMapLatest { [weak self] term, email, pw -> Observable<TokenData> in
                guard let self = self else { return .empty() }
                return self.repository.requestSignUp(email: email, password: pw, termsIds: term)
                    .catch { error in
                        // TODO: 서버 에러 처리
                        return .empty()
                        }
            }.observe(on: MainScheduler.instance)
        return Output(pwIsValid: pwValid, pwConfirmIsValid: pwConfirmValid, signUpOutput: signUpOutput)
    }
}
