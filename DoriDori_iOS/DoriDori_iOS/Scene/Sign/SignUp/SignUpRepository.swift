//
//  SignUpRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/15.
//

import RxSwift

protocol SignUpReqestable: AnyObject {
    func fetchTermsOfService() -> Observable<[TermsModel]>
    func requestEmailSend(email: String) -> Observable<EmptyModel>
    func confirmAuthNumber(email: String, authNumber: String) -> Observable<EmptyModel>
    func requestSignUp(email: String, password: String, termsIds: [String]) -> Observable<EmailSignUpModel>
}

final class SignUpRepository: SignUpReqestable {
    
    func fetchTermsOfService() -> Observable<[TermsModel]> {
        Network().request(api: TermsOfServiceRequest(), responseModel: ResponseModel<[TermsModel]>.self)
    }
    
    func requestEmailSend(email: String) -> Observable<EmptyModel> {
        Network().request(api: EmailSendRequest.init(email: email), responseModel: ResponseModel<EmptyModel>.self)
    }
    
    func confirmAuthNumber(email: String, authNumber: String) -> Observable<EmptyModel> {
        Network().request(api: EmailCertRequest.init(email: email, certificationNumber: authNumber), responseModel: ResponseModel<EmptyModel>.self)
    }
    
    func requestSignUp(email: String, password: String, termsIds: [String]) -> Observable<EmailSignUpModel> {
        Network().request(api: EmailSignUpRequest.init(email: email, password: password, termsIds: termsIds), responseModel: ResponseModel<EmailSignUpModel>.self)
    }
}
