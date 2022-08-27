//
//  UserDefault+Value.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/17.
//

import Foundation

typealias AccessToken = String
typealias RefreshToken = String

extension UserDefaults {
    // 앞으로 여기에 key 값으로 추가 부탁드릴게요!
    @OptionalUserDefault(key: "accessToken")
    static var accessToken: AccessToken?
    
    @UserDefault(key: "userID", defaultValue: nil)
    @OptionalUserDefault(key: "refreshToken")
    static var refreshToken: RefreshToken?
    
    @OptionalUserDefault(key: "userID")
    static var userID: UserID?
}
