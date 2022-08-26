//
//  SignUpViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/26.
//

import RxSwift
import RxCocoa

final class SignUpViewModel {
    
    private let repository: SignUpRepository = .init()
    private var disposeBag = DisposeBag()
    
    let termsIds: PublishSubject<[String]> = .init()
    let email: PublishSubject<String> = .init()
    let password: PublishSubject<String> = .init()
    
    struct Output {
        let signUpAPIOutput: Observable<Void>
    }
    
    func transform() -> Output {
        
        // TODO:  그냥 회원가입 레파지토리 받아와서 APi 쏴서 보내
        let output = Observable.combineLatest(termsIds, email, password) { ids, email, password in
            return EmailSignUpModel(email: email, password: password, termsIds: ids)
        }
        let signUpOutput = output.flatMap { [weak self] model -> Observable<Void> in
            guard let self = self else { return .empty() }
            return self.repository.requestSignUp(email: model.email, password: model.password, termsIds: model.termsIds)
                .catch({ error in
                    // TODO: 회원가입 실패시 에러처리
                    return .empty()
                }).map { _ in
                    return
                }
        }.observe(on: MainScheduler.instance)
        
        return Output(signUpAPIOutput: signUpOutput)
    }

}
