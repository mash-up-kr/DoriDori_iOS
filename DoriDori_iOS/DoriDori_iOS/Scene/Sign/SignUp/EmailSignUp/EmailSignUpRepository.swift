//
//  EmailSignInRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/15.
//

import RxSwift

protocol EmailCertificationReqestable: AnyObject {
    func requestEmail(email: String) -> Observable<EmptyModel>
}

final class EmailCertificationRepository: EmailCertificationReqestable {
    func requestEmail(email: String) -> Observable<EmptyModel> {
        Network().request(api: EmailSignUpRequest.init(email: email), responseModel: ResponseModel<EmptyModel>.self)
    }
}
