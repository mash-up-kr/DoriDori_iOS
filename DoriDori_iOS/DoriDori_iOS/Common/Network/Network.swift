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
typealias HTTPHeaders = Alamofire.HTTPHeaders

struct Network {
    private let baseURL: String
    init(baseURL: String = "https://doridori.ga") {
        self.baseURL = baseURL
    }

    func request<Model: Decodable>(
        api: Requestable,
        responseModel: ResponseModel<Model>.Type
    ) -> Observable<Model> {
        Observable<Model>.create { observer in
            AF.request(
                "\(baseURL)\(api.path)",
                method: api.method,
                parameters: api.parameters,
                encoding: JSONEncoding.default,
                headers: api.headers
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
                        if isSuccess {
                            if let data = responseModel.data {
                                observer.onNext(data)
                            } else { observer.onError(DoriDoriError.noData) }
                        } else {
                            if let errModel = responseModel.error {
                                observer.onError(errModel)
                            } else {
                                observer.onError(DoriDoriError.noErrorModel)
                            }
                        }
                    } else { observer.onError(DoriDoriError.fieldError) }
                case .failure(let AFError):
                    observer.onError(AFError)
                }
            }
            return Disposables.create()
        }
    }
}
