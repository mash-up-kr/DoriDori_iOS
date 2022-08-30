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
    @OptionalUserDefault(key: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE3NTQyMzE0MTQsInVzZXJJZCI6IjYyZDdmNDc3NmFkOTZjNTFkNDMzMGVhMiJ9.qYld9Je775prztT4oGWZ-4FDYg27TVJ24h1mQZG0fiE")
    static var accessToken: AccessToken?
    
    @OptionalUserDefault(key: "refreshToken")
    static var refreshToken: RefreshToken?
    
    @OptionalUserDefault(key: "userID")
    static var userID: UserID?
}
