//
//  EmailSignInRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/22.
//

import RxSwift

protocol EmailSignInReqestable: AnyObject {
    func requestLogin(email: String, loginType: String, password: String) -> Observable<TokenData>
}

final class EmailSignInRepository: EmailSignInReqestable {
    func requestLogin(email: String, loginType: String, password: String) -> Observable<TokenData> {
        Network().request(api: EmailSignInRequest.init(email: email, loginType: loginType, password: password), responseModel: ResponseModel<TokenData>.self)
    }
    
}
