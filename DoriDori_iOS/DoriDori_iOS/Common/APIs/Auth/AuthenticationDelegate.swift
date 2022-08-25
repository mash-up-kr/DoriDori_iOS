//
//  AuthenticationDelegate.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/22.
//

import Foundation

protocol AuthenticationDelegate {
    func signIn(accessToken: String, refreshToken: String)
    func notSignIn()
}
