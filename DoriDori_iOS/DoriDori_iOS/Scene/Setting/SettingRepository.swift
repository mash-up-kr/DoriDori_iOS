//
//  SettingRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/30.
//

import Foundation
import RxSwift

protocol SettingRequestable: AnyObject {
    func userWithdraw() -> Observable<Bool>
}

final class SettingRepsotiory: SettingRequestable {
    func userWithdraw() -> Observable<Bool> {
        Network().request(api: UserWithdrawRequest(), responseModel: ResponseModel<Bool>.self)
    }
}
