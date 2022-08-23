//
//  TermsOfServiceViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/21.
//

import RxSwift
import RxCocoa
final class TermsOfServiceViewModel {
    
    private let repostiory: TermsOfServiceRepository = .init()
    
    struct Input {
        let allAgree: Observable<Void>
        let useAgree: Observable<Void>
        let locationAgree: Observable<Void>
    }
    
    struct Output {
//        let allAgree: Observable<Bool>
//        let useAgree: Observable<Bool>
//        let locationAgree: Observable<Bool>
//        let isValidButton: Observable<Bool>
        
        //약관 내용
        let useContent: Observable<TermsModel>
        let locationContent: Observable<TermsModel>
    }
    
    func transform(input: Input) -> Output {
        let terms = self.repostiory.fetchTermsOfSerice().share()
        
        let useContent = terms.compactMap { $0[safe: 0] }
            .map { model in
                return TermsModel(id: model.id,
                           title: model.title,
                           content: model.content,
                           necessary: model.necessary)
            }
        
        let locationContent = terms.compactMap { $0[safe: 1] }
            .map { model in
                return TermsModel(id: model.id,
                           title: model.title,
                           content: model.content,
                           necessary: model.necessary)
            }
        return Output(useContent: useContent, locationContent: locationContent)
            
    }
   
    

}
