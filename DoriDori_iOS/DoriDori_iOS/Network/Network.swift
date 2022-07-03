//
//  Network.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/06/25.
//

import Foundation
import Alamofire
import RxSwift

typealias HTTPMethod = Alamofire.HTTPMethod

struct Network {
    private let baseURL: String
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetch<Model: Decodable>(
        request: Requestable,
        responseModel: ResponseModel<Model>.Type
    ) -> Single<Model> {
        Single<Model>.create { observer in
            AF.request(
                "\(baseURL)\(request.path)",
                method: request.method,
                parameters: request.parameters,
                headers: nil
            )
            .responseDecodable(
                of: responseModel,
                queue: .init(
                    label: "DoriDori_network_queue",
                    qos: .background,
                    attributes: .concurrent
                )
            ) { dataResponse in
                debugPrint(dataResponse)
                switch dataResponse.result {
                case .success(let responseModel):
                    if let isSuccess = responseModel.success {
                        if !isSuccess {
                            if let errModel = responseModel.error {
                                observer(.failure(errModel))
                            } else { observer(.failure(DoriDoriError.no_errorModel)) }
                        } else {
                            if let data = responseModel.data {
                                observer(.success(data))
                            } else { observer(.failure(DoriDoriError.no_data)) }
                        }
                    } else { observer(.failure(DoriDoriError.field_error)) }
                case .failure(let AFError):
                    observer(.failure(AFError))
                }
            }
            return Disposables.create()
        }
    }
}
