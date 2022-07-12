//
//  UnderLineData.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/10.
//

public enum TextFieldType: String {
    case email = "이메일"
    case password = "비밀번호"
    case nickname = "닉네임"
    case authNumber = "인증번호"
}

public enum TextFieldErrorType: String {
    case email = "이메일 주소를 확인해주세요."
    case password = "비밀번호를 확인해주세요."
    case nickname = "닉네임은 7자리 이내로 설정해주세요."
    case authNumber = "인증번호를 확인해주세요."
}


public struct TextFieldData {
    public let type: TextFieldType
    public let errorType: TextFieldErrorType
    public var validState: Bool?
    
    public init(type: TextFieldType, errorType: TextFieldErrorType, validState: Bool? = nil) {
        self.type = type
        self.errorType = errorType
        self.validState = validState
    }
}
