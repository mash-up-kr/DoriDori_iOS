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
            guard let authentication = self.fetchAuthentication() else { return Disposables.create() }
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(authentication.accessToken)"
            ]
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
                        refreshToken: authentication.refreshToken,
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
        let accessToken = UserDefaults.accessToken ?? dummyAccessToken
        let refrehToken = UserDefaults.refreshToken ?? dummyRefreshToken
        return (accessToken, refrehToken)
    }

    
    private func parseResponse<Model: Codable>(
        response: ResponseModel<Model>,
        refreshToken: RefreshToken,
        api: Requestable,
        responseModel: ResponseModel<Model>.Type,
        to observer: AnyObserver<Model>
    ) {
        if let isSuccess = response.success {
            if isSuccess {
                if let data = response.data {
                    observer.onNext(data)
                } else { observer.onError(DoriDoriError.noData) }
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
