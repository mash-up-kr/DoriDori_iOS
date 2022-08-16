//
//  HomeRepository.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/10.
//

import RxSwift

protocol HomeRepositoryRequestable {
    func requestHomeHeaderData() -> Observable<[MyWard]>
}

struct HomeRepository: HomeRepositoryRequestable {
    // TODO: - API 붙여야됨
    func requestHomeHeaderData() -> Observable<[MyWard]> {
        Network().request(api: MyWardRequest(), responseModel: ResponseModel<[MyWard]>.self)
    }
}
