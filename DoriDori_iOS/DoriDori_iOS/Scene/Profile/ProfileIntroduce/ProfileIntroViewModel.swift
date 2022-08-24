//
//  ProfileIntroduceViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/25.
//

import RxSwift

final class ProfileIntroViewModel: ViewModelProtocol {
    struct Input {
        let profile: Observable<String>
        let profileStringCount: Int
    }
    
    struct Output {
        let btnInEnable: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let output = input.profile
            .map { str -> Bool in
                str.count <= input.profileStringCount && !str.isEmpty
        }
        return Output(btnInEnable: output)
    }
}
