//
//  TermsOfServiceViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/21.
//

import RxSwift

final class TermsOfServiceViewModel {
    
    struct Input {
        let allAgree: Observable<Bool>
    }
    
    struct Output {
        let isValidButton: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        return Output(isValidButton: input.allAgree)
    }
   
    

}
