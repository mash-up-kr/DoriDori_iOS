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

protocol Requestable {
    var url: String { get }
    var parameters: [String: Any] { get }
    var method: HTTPMethod { get }
}

struct Network {
    func fetch<Model: Decodable>(
        request: Requestable,
        responseModel: ResponseModel<Model>.Type
    ) async throws -> ResponseModel<Model> {
        return try await withUnsafeThrowingContinuation({ continuation in
            AF.request(
                request.url,
                method: request.method,
                parameters: request.parameters,
                headers: nil
            )
            .responseDecodable(
                of: responseModel,
                queue: .init(label: "DoriDori_network_queue", qos: .background, attributes: .concurrent)
            ) { dataResponse in
                debugPrint(dataResponse)
                switch dataResponse.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    func fetch2<Model: Decodable>(
        request: Requestable,
        responseModel: ResponseModel<Model>.Type
    ) -> Single<ResponseModel<Model>> {
        Single<ResponseModel<Model>>.create { observer in
            AF.request(
                request.url,
                method: request.method,
                parameters: request.parameters,
                headers: nil
            )
            .responseDecodable(
                of: responseModel,
                queue: .init(label: "DoriDori_network_queue", qos: .background, attributes: .concurrent)
            ) { dataResponse in
                debugPrint(dataResponse)
                switch dataResponse.result {
                case .success(let data):
                    observer(.success(data))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
