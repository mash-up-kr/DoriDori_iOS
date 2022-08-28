//
//  ProfileRepository.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/27.
//

import RxSwift

protocol ProfileReqeustable: AnyObject {
    func updateNickname(nickname: String) -> Observable<Bool>
    func updateProfile(description: String, tags: [String], representativeWardId: String?) -> Observable<Bool>
//    func uploadProfileImage(image: File)
}

final class ProfileRepository: ProfileReqeustable {
    
    func updateNickname(nickname: String) -> Observable<Bool> {
        Network().request(api: NicknameRequest(nickname: nickname), responseModel: ResponseModel<Bool>.self)
    }
    
    func updateProfile(description: String, tags: [String], representativeWardId: String?) -> Observable<Bool> {
        Network().request(api: ProfileRequest(description: description, tags: tags), responseModel: ResponseModel<Bool>.self)
    }
}
