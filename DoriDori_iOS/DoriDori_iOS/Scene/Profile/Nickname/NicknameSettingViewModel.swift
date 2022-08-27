//
//  NicknameSettingViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameSettingViewModel: ViewModelProtocol {
    
    private let repository: ProfileRepository = .init()
    
    enum Error: String {
        case duplicateNickname = "DUPLICATED_NICKNAME"
    }

    struct Input {
        let nickname: Observable<String>
        let tappedConfirm: Observable<Void>
    }
    
    struct Output {
        let buttonOutput: Observable<Bool>
        let nicknameOutput: Driver<Bool>
        let errorMsg: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let output = input.nickname.map { $0.nicknameValidCheck }
        
        let errorRelay = PublishRelay<String>()
        let nickname = input.tappedConfirm.withLatestFrom(input.nickname).flatMapLatest { [weak self] nickname -> Observable<Bool> in
            guard let self = self else { return .empty() }
            return self.repository.updateNickname(nickname: nickname)
                .catch { error in
                    guard let errorModel = error.toErrorModel else { return .empty() }
                    if errorModel.code == Error.duplicateNickname.rawValue {
                        guard let errorMsg = errorModel.message else {
                            return .empty()
                        }
                        errorRelay.accept(errorMsg)
                    }
                    return .empty()
                }
        }
        
        return Output(buttonOutput: output, nicknameOutput: nickname.asDriver(onErrorJustReturn: false), errorMsg: errorRelay.asSignal())

        
    }
}
