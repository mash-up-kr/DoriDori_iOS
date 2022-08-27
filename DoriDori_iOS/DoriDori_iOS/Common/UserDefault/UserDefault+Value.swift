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
    @UserDefault(key: "accessToken", defaultValue: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE2NjE1ODI5NDMsInVzZXJJZCI6IjYzMDc0NjI4NGEwZTA0N2JmNWVmM2I4ZiJ9.lbs4y7QfOGgK5p4X0NUaQKgRPiWmvVX8kpa9phXssbI")
    static var accessToken: AccessToken
    
    @UserDefault(key: "refreshToken", defaultValue: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYW5nd2lkYWUiLCJleHAiOjE2NzcxMzEzNDMsInVzZXJJZCI6IjYzMDc0NjI4NGEwZTA0N2JmNWVmM2I4ZiJ9.PAKU-AazYM6DlOCVYnI4JAOkn7JRBpb_Yb55tuWuHDw")
    static var refreshToken: RefreshToken
    
    @UserDefault(key: "userID", defaultValue: nil)
    static var userID: UserID?
}
