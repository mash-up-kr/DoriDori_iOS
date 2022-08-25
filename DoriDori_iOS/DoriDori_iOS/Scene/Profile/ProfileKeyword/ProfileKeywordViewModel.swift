//
//  ProfileKeywordViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/24.
//

import RxSwift
import RxCocoa

final class ProfileKeywordViewModel: ViewModelProtocol {
    
    private let keywordEdit: BehaviorRelay<Bool> = .init(value: true)
    private var disposeBag = DisposeBag()
    
    struct Input {
        let editTap: Observable<Void>
    }
    
    struct Output {
        let editState: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        var edit = self.keywordEdit.value
        input.editTap.bind(onNext: { [weak self] _ in
            edit.toggle()
            self?.keywordEdit.accept(edit)
        }).disposed(by: disposeBag)

        return Output(editState: keywordEdit.asDriver())
    }
    
}
