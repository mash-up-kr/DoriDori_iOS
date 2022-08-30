//
//  SignUpRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/15.
//

import RxSwift

protocol SignUpReqestable: AnyObject {
    func fetchTermsOfService() -> Observable<[TermsModel]>
    func requestEmailSend(email: String) -> Observable<Bool>
    func confirmAuthNumber(email: String, authNumber: String) -> Observable<Bool>
    func requestSignUp(email: String, password: String, termsIds: [String]) -> Observable<TokenData>
}

final class SignUpRepository: SignUpReqestable {
    
    func fetchTermsOfService() -> Observable<[TermsModel]> {
        Network().request(api: TermsOfServiceRequest(), responseModel: ResponseModel<[TermsModel]>.self)
    }
    
    func requestEmailSend(email: String) -> Observable<Bool> {
        Network().request(api: EmailSendRequest.init(email: email), responseModel: ResponseModel<Bool>.self)
    }
    
    func confirmAuthNumber(email: String, authNumber: String) -> Observable<Bool> {
        Network().request(api: EmailCertRequest.init(email: email, certificationNumber: authNumber), responseModel: ResponseModel<Bool>.self)
    }
    
    func requestSignUp(email: String, password: String, termsIds: [String]) -> Observable<TokenData> {
        Network().request(api: EmailSignUpRequest.init(email: email, password: password, termsIds: termsIds), responseModel: ResponseModel<TokenData>.self)
    }
}
