//
//  UnderLineData.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/10.
//

import RxSwift


enum TextFieldType: String {
    case email = "이메일"
    case password = "비밀번호"
    case nickname = "닉네임"
    case authNumber = "인증번호"
}

enum TextFieldPlaceHolder: String {
    case email = "DoriDori@naver.com"
    case password = "비밀번호 입력"
    case nickname = "ex) 도리를 찾아서"
    case authNumber = "6자리 숫자"
}

enum TextFieldErrorMessage: String {
    case email = "이메일 주소를 확인해주세요."
    case password = "비밀번호를 확인해주세요."
    case nickname = "닉네임은 7자리 이내로 설정해주세요."
    case authNumber = "인증번호를 확인해주세요."
}

