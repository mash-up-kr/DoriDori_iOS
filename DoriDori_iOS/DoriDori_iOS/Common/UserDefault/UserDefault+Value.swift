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
    
    @OptionalUserDefault(key: "refreshToken")
    static var refreshToken: RefreshToken?
    
    @OptionalUserDefault(key: "userID")
    static var userID: UserID?
    
    @UserDefault(key: "longitude", defaultValue: 127.027926)
    static var longitude: Double
    
    @UserDefault(key: "latitude", defaultValue: 37.497175)
    static var latitude: Double
}
