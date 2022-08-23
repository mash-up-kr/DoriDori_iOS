//
//  TermsOfServiceRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/23.
//

import Foundation
import RxSwift

protocol TermsOfServiceRequestable: AnyObject {
    func fetchTermsOfSerice() -> Observable<[TermsModel]>
}

final class TermsOfServiceRepository: TermsOfServiceRequestable {
    func fetchTermsOfSerice() -> Observable<[TermsModel]> {
        Network().request(api: TermsOfServiceRequest(), responseModel: ResponseModel<[TermsModel]>.self)
    }
}
