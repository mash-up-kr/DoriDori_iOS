//
//  HomeRepository.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/10.
//

import RxSwift
import Foundation

protocol HomeRepositoryRequestable {
    func requestHomeHeaderData() -> Observable<[MyWard]>
    func requestHomeData(lastId: String?, latitude: Double, longitude: Double, meterDistance: Double, size: Int) -> Observable<HomeSpeechs>
    func like(id: String) -> Observable<HomeLike>
    func dislike(id: String) -> Observable<HomeLike>
    func comment(postId: String) -> Observable<HomeSpeechInfo>
}

struct HomeRepository: HomeRepositoryRequestable {
    // TODO: - API 붙여야됨
    func requestHomeHeaderData() -> Observable<[MyWard]> {
        Network().request(api: MyWardRequest(), responseModel: ResponseModel<[MyWard]>.self)
    }
    
    // TODO: - Model 하나 만들어서 데이터 전달하기
    func requestHomeData(lastId: String?, latitude: Double, longitude: Double, meterDistance: Double, size: Int) -> Observable<HomeSpeechs> {
        Network().request(api: HomeSpeechsReqeust(lastId: lastId, latitude: latitude, longitude: longitude, meterDistance: meterDistance, size: size), responseModel: ResponseModel<HomeSpeechs>.self)
    }
    
    func like(id: String) -> Observable<HomeLike> {
        Network().request(api: HomeLikeRequest(id: id), responseModel: ResponseModel<HomeLike>.self)
    }
    
    func dislike(id: String) -> Observable<HomeLike> {
        Network().request(api: HomeDislikeRequest(id: id), responseModel: ResponseModel<HomeLike>.self)
    }
    
    func comment(postId: String) -> Observable<HomeSpeechInfo> {
        Network().request(api: HomeCommentRequest(postId: postId), responseModel: ResponseModel<HomeSpeechInfo>.self)
    }
}
