//
//  HomeRepository.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/10.
//

import RxSwift

protocol HomeRepositoryRequestable {
    // TODO: - 데이터 타입에 맞게 수정
    func request() -> Observable<Void>
}

struct HomeRepository: HomeRepositoryRequestable {
    func request() -> Observable<Void> {
        return Observable.just(())
    }
}
