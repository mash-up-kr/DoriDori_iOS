//
//  MyPageRepository.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import Foundation
import RxSwift

protocol MyPageRequestable: AnyObject {
    func fetchMyProfile(userID: UserID) -> Observable<UserInfoModel>
}

final class MyPageRepository: MyPageRequestable {
    func fetchMyProfile(userID: UserID) -> Observable<UserInfoModel> {
        Network().request(
            api: UserInfoRequest(userID: userID),
            responseModel: ResponseModel<UserInfoModel>.self
        )
    }
}
