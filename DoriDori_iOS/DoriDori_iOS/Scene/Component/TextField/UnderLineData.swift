//
//  UnderLineData.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/10.
//

public enum UnderLineType: String {
    case email = "이메일"
    case password = "비밀번호"
    case nickname = "닉네임"
    case authNumber = "인증번호"
}

public struct UnderLineData {
    public let type: UnderLineType
    public var validState: Bool?
    
    public init(type: UnderLineType, validState: Bool? = nil) {
        self.type = type
        self.validState = validState
    }
}
