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
typealias ParameterEncoding = Alamofire.ParameterEncoding
typealias URLEncoding = Alamofire.URLEncoding
typealias JSONEncoding = Alamofire.JSONEncoding

struct Network {
    private let baseURL: String
    private let authenticationRepository: AuthenticationRequestable
    private let disposeBag: DisposeBag
    
    init(
        baseURL: String = "https://doridori.ga",
        authenticationRepository: AuthenticationRequestable = AuthenticationRepository()
    ) {
        self.baseURL = baseURL
        self.authenticationRepository = authenticationRepository
        self.disposeBag = .init()
    }

    func request<Model: Decodable>(
        api: Requestable,
        responseModel: ResponseModel<Model>.Type
    ) -> Observable<Model> {

        return Observable<Model>.create { observer in
            var headers: HTTPHeaders?
            var refreshToken: RefreshToken?
            headers = [
                "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE3NTQyMzE0MTQsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.qYld9Je775prztT4oGWZ-4FDYg27TVJ24h1mQZG0fiE"
            ]
            if let authentication = self.fetchAuthentication() {
                headers = [
                    "Authorization": "Bearer \(authentication.accessToken)"
                ]
                refreshToken = authentication.refreshToken
            }
            AF.request(
                "\(baseURL)\(api.path)",
                method: api.method,
                parameters: api.parameters,
                encoding: api.encoding,
                headers: headers
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
                case .success(let response):
                    self.parseResponse(
                        response: response,
                        refreshToken: refreshToken,
                        api: api,
                        responseModel: responseModel,
                        to: observer
                    )
                case .failure(let AFError):
                    observer.onError(AFError)
                }
            }
            return Disposables.create()
        }
    }
}

extension Network {
    
    private func refresh<Model: Codable>(
        refreshToken: RefreshToken,
        retryAPI: Requestable,
        retryResponseModel: ResponseModel<Model>.Type,
        observer: AnyObserver<Model>
    ) {
        self.authenticationRepository.refresh(refreshToken: refreshToken)
            .compactMap { $0.accessToken }
            .do(onNext: { accessToken in
                UserDefaults.accessToken = accessToken
            })
            .flatMapLatest({ _ in
                return self.request(
                    api: retryAPI,
                    responseModel: retryResponseModel
                )
            })
            .catch({ error in
                return .empty()
            })
            .bind(onNext: { data in
                observer.onNext(data)
            })
            .disposed(by: self.disposeBag)
    }
    
    
    private func fetchAuthentication() -> (accessToken: AccessToken, refreshToken: RefreshToken)? {
        guard let accessToken = UserDefaults.accessToken,
              let refrehToken = UserDefaults.refreshToken else { return
            
            ("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE3NTQyMzE0MTQsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.qYld9Je775prztT4oGWZ-4FDYg27TVJ24h1mQZG0fiE", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE2NzYyMTY2NDYsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.SjS4nCB9AfiRG3v8cbYUdUIXsrJSbePZM-mIyjOBsiA")
        }
        return (accessToken, refrehToken)
    }

    
    private func parseResponse<Model: Codable>(
        response: ResponseModel<Model>,
        refreshToken: RefreshToken?,
        api: Requestable,
        responseModel: ResponseModel<Model>.Type,
        to observer: AnyObserver<Model>
    ) {
        guard let refreshToken = refreshToken else { return }
        if let isSuccess = response.success {
            if isSuccess {
                if let data = response.data {
                    observer.onNext(data)
                } else {
                    observer.onError(DoriDoriError.noData)
                }
            } else {
                if let errModel = response.error {
                    if errModel.code == DoriDoriError.TOKEN_EXPIRED.rawValue {
                        self.refresh(
                            refreshToken: refreshToken,
                            retryAPI: api,
                            retryResponseModel: responseModel,
                            observer: observer
                        )
                    } else {
                        observer.onError(errModel)
                    }
                } else {
                    observer.onError(DoriDoriError.noErrorModel)
                }
            }
        } else { observer.onError(DoriDoriError.fieldError) }
    }
}
