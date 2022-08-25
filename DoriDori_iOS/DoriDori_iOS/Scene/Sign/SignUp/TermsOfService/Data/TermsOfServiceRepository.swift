//
//  TermsOfServiceRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/23.
//

import Foundation
import RxSwift

protocol TermsOfServiceRequestable: AnyObject {
    func fetchTermsOfService() -> Observable<[TermsModel]>
}

final class TermsOfServiceRepository: TermsOfServiceRequestable {
    func fetchTermsOfService() -> Observable<[TermsModel]> {
        Network().request(api: TermsOfServiceRequest(), responseModel: ResponseModel<[TermsModel]>.self)
    }
}
