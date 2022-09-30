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
    func like(id: String) -> Observable<Bool>
    func dislike(id: String) -> Observable<Bool>
    func comment(postId: String) -> Observable<HomeSpeechInfo>
    func report(type: ReportType, targetId: String) -> Observable<Bool>
    func deleteMyQuestion(id: String) -> Observable<Bool>
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
    
    func like(id: String) -> Observable<Bool> {
        Network().request(api: HomeLikeRequest(id: id), responseModel: ResponseModel<Bool>.self)
    }
    
    func dislike(id: String) -> Observable<Bool> {
        Network().request(api: HomeDislikeRequest(id: id), responseModel: ResponseModel<Bool>.self)
    }
    
    func comment(postId: String) -> Observable<HomeSpeechInfo> {
        Network().request(api: HomeCommentRequest(postId: postId), responseModel: ResponseModel<HomeSpeechInfo>.self)
    }
    
    func report(type: ReportType, targetId: String) -> Observable<Bool> {
        Network().request(api: ReportRequest(type: type, targetID: targetId), responseModel: ResponseModel<Bool>.self)
    }
    
    func deleteMyQuestion(id: String) -> Observable<Bool> {
        Network().request(api: DeletePostRequest(postID: id), responseModel: ResponseModel<Bool>.self)
    }
}
