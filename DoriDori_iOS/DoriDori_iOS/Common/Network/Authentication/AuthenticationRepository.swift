//
//  AuthenticationRepository.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/23.
//

import Foundation
import RxSwift

protocol AuthenticationRequestable: AnyObject {
    func refresh(refreshToken: RefreshToken) -> Observable<RefreshModel>
}

final class AuthenticationRepository: AuthenticationRequestable {
    func refresh(refreshToken: RefreshToken) -> Observable<RefreshModel> {
        return Network().request(
            api: RefreshTokenRequest(),
            responseModel: ResponseModel<RefreshModel>.self
        )
    }
}
