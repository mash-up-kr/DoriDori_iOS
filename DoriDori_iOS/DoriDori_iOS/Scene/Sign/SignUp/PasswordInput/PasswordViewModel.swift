//
//  PasswordViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/30.
//

import RxSwift
import RxCocoa

final class PasswordViewModel: ViewModelProtocol {
    struct Input {
        let password: Observable<String>
        let passwordConfirm: Observable<String>
        let confirmButtonTap: Observable<Void>
    }
    
    struct Output {
        let passwordIsValid: Observable<Bool>
        let finalConfirm: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let passwordIsValid = input.passwordConfirm.map {
            $0.passwordValidCheck
        }
        
        let finalConfirm = Observable.combineLatest(input.password.filter { !$0.isEmpty }, input.passwordConfirm.filter { !$0.isEmpty }) { p1, p2 in
            p1 == p2 && p1.passwordValidCheck
        }
        
        return Output(passwordIsValid: passwordIsValid, finalConfirm: finalConfirm)
    }
}
