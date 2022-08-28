//
//  ProfileKeywordViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/24.
//

import RxSwift
import RxCocoa

final class ProfileKeywordSettingViewModel: ViewModelProtocol {
    
    enum ProfileError: String {
        case authFail = "AUTHENTICATED_FAIL"
        case tokenExpired = "TOKEN_EXPIRED"
    }
    
    private let keywordEdit: BehaviorRelay<Bool> = .init(value: true)
    let tags = PublishRelay<[String]>()
    private let repository: ProfileRepository = .init()
    private var disposeBag = DisposeBag()
    
    struct Input {
        let editTap: Observable<Void>
        let startTap: Observable<Void>
        let description: Observable<String>
    }
    
    struct Output {
        let editState: Driver<Bool>
        let profileOutput: Driver<Bool>
        let errorMsg: Signal<String>

    }
    
    func transform(input: Input) -> Output {
        var edit = self.keywordEdit.value
        input.editTap.bind(onNext: { [weak self] _ in
            edit.toggle()
            self?.keywordEdit.accept(edit)
        }).disposed(by: disposeBag)
        
        let errorRelay = PublishRelay<String>()
        let output = input.startTap.withLatestFrom(Observable.combineLatest(input.description, tags) { ($0, $1) })
            .flatMapLatest { description, tags -> Observable<Bool> in
                return self.repository.updateProfile(description: description, tags: tags, representativeWardId: nil)
                    .catch { error in
                        guard let errorModel = error.toErrorModel else { return .empty() }
                        if errorModel.code == ProfileError.authFail.rawValue &&
                            errorModel.code == ProfileError.tokenExpired.rawValue {
                            guard let errorMsg = errorModel.message else {
                                return .empty()
                            }
                            errorRelay.accept(errorMsg)
                        }
                        return .empty()
                    }
            }.observe(on: MainScheduler.instance)
            
      
        return Output(editState: keywordEdit.asDriver(), profileOutput: output.asDriver(onErrorJustReturn: false), errorMsg: errorRelay.asSignal())

    }
    
}
