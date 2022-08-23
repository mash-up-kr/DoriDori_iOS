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
    
    struct Input {
        let nickname: Observable<String>
    }
    
    struct Output {
        let buttonOutput: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let output = input.nickname.map { $0.nicknameValidCheck }
        return Output(buttonOutput: output)
    }
}
