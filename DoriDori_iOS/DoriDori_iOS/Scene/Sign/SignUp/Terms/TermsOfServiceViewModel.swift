//
//  TermsOfServiceViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/21.
//

import RxSwift
import RxCocoa

final class TermsOfServiceViewModel {
    
    private let repostiory: SignUpRepository = .init()
    private let allAgreeRelay: BehaviorRelay<Bool> = .init(value: false)
    private let useAgreeRelay: BehaviorRelay<Bool> = .init(value: false)
    private let personalInfoAgreeRelay: BehaviorRelay<Bool> = .init(value: false)
    private let locationAgreeRelay: BehaviorRelay<Bool> = .init(value: false)
    
    private let useContentRelay = PublishRelay<TermsModel>()
    private let personalContentRelay = PublishRelay<TermsModel>()
    private let locationContentRelay = PublishRelay<TermsModel>()
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let allAgree: Observable<Void>
        let useAgree: Observable<Void>
        let personalInfoAgree: Observable<Void>
        let locationAgree: Observable<Void>
    }
    
    struct Output {
        let allAgreeOutput: Driver<Bool>
        let useAgreeOutput: Driver<Bool>
        let personalInfoAgreeOutput: Driver<Bool>
        let locationAgreeOutput: Driver<Bool>
        let buttonOutput: Observable<Bool>

        let useContent: Observable<TermsModel>
        let locationContent: Observable<TermsModel>
        let personalInfoContent: Observable<TermsModel>
    }
    
    func transform(input: Input) -> Output {
        
        var all = self.allAgreeRelay.value
        var use = self.useAgreeRelay.value
        var personalInfo = self.personalInfoAgreeRelay.value
        var location = self.locationAgreeRelay.value
        
        input.allAgree
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                all.toggle()
                use = all
                location = all
                personalInfo = all
                self.allAgreeRelay.accept(all)
                self.useAgreeRelay.accept(use)
                self.personalInfoAgreeRelay.accept(personalInfo)
                self.locationAgreeRelay.accept(location)
            }).disposed(by: disposeBag)
        
        input.useAgree.bind(onNext: { [weak self] _ in
            use.toggle()
            if !use { all = false }
            else if use && location && personalInfo { all = true }
            self?.allAgreeRelay.accept(all)
            self?.useAgreeRelay.accept(use)
            self?.personalInfoAgreeRelay.accept(personalInfo)
        }).disposed(by: disposeBag)
        
        input.locationAgree.bind(onNext: { [weak self] _ in
            location.toggle()
            if !location { all = false }
            else if use && location && personalInfo { all = true }
            self?.allAgreeRelay.accept(all)
            self?.locationAgreeRelay.accept(location)
            self?.personalInfoAgreeRelay.accept(personalInfo)
        }).disposed(by: disposeBag)
        
        input.personalInfoAgree.bind(onNext: { [weak self] _ in
            personalInfo.toggle()
            if !personalInfo { all = false }
            else if use && location && personalInfo { all = true }
            self?.allAgreeRelay.accept(all)
            self?.locationAgreeRelay.accept(location)
            self?.personalInfoAgreeRelay.accept(personalInfo)
        }).disposed(by: disposeBag)
        
        let buttonOutput = Observable.combineLatest(allAgreeRelay, useAgreeRelay, locationAgreeRelay, personalInfoAgreeRelay) { $0 && $1 && $2 && $3 }
                
        let terms = self.repostiory.fetchTermsOfService().share()
        
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
        
        let personalInfoContent = terms.compactMap { $0[safe: 2] }
            .map { model in
                return TermsModel(id: model.id,
                                  title: model.title,
                                  content: model.content,
                                  necessary: model.necessary)
            }
        
        
        return Output(allAgreeOutput: allAgreeRelay.asDriver(),
                      useAgreeOutput: useAgreeRelay.asDriver(),
                      personalInfoAgreeOutput: personalInfoAgreeRelay.asDriver(),
                      locationAgreeOutput: locationAgreeRelay.asDriver(),
                      buttonOutput: buttonOutput,
                      useContent: useContent,
                      locationContent: locationContent,
                      personalInfoContent: personalInfoContent)
    }
 
}
