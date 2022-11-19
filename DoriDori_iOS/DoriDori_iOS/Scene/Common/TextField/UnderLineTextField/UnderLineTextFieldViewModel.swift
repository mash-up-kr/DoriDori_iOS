//
//  UnderLineTextFieldViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/30.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UnderLineTextFieldViewModel {
    enum TextFieldType: String {
        case email = "이메일"
        case password = "비밀번호"
        case passwordConfirm = "비밀번호 확인"
        case nickname = "닉네임"
        case authNumber = "인증번호"
        case profile, profileKeyword
    }
    
    enum TextFieldPlaceHolder: String {
        case email = "DoriDori@naver.com"
        case password = "6~20자 비밀번호 입력"
        case passwordConfirm = "비밀번호 확인"
        case nickname = "ex) 도리를 찾아서"
        case authNumber = "6자리 숫자"
        case profile = "ex) 안녕하세요! 도리도리입니다."
        case profileKeyword = "ex) MBTI, 카페, 연애"
    }
    
    enum TextFieldErrorMessage: String {
        case email = "이메일 주소를 확인해주세요."
        case password = "비밀번호를 확인해주세요."
        case nickname = "닉네임은 7자리 이내로 설정해주세요."
    }
    
    private(set) var inputContentType: UITextContentType = .emailAddress
    private(set) var returnKeyType: UIReturnKeyType = .default
    private(set) var keyboardType: UIKeyboardType = .default
    private(set) var isSecureTextEntry: Bool = false
    private(set) var titleLabelType: TextFieldType = .email
    private(set) var inputPlaceHolder: TextFieldPlaceHolder = .email
    private(set) var errorMsgAndTypeCheck: TextFieldErrorMessage = .email
    private(set) var stringCountIsHidden: Bool = true
    private(set) var totalStringCount: Int = 0
    private(set) var authNumberTimer: Bool = true
    private(set) var authNumberResend: Bool = true
    
    func setUpTitleType(_ titleType: TextFieldType) {
        self.titleLabelType = titleType
        configureTextField(titleType)
    }
    
    func setUpInputType(_ inputType: UITextContentType) {
        self.inputContentType = inputType
    }
    
    func setUpKeyboardType(_ keyboardType: UIKeyboardType) {
        self.keyboardType = keyboardType
    }
    
    // MARK: - func
    private func configureTextField(_ type: TextFieldType) {
        switch type {
        case .email:
            errorMsgAndTypeCheck = .email
            inputPlaceHolder = .email
        case .password:
            errorMsgAndTypeCheck = .password
            inputPlaceHolder = .password
            stringCountIsHidden = false
            totalStringCount = 20
            isSecureTextEntry = true
        case .passwordConfirm:
            errorMsgAndTypeCheck = .password
            inputPlaceHolder = .passwordConfirm
            stringCountIsHidden = false
            totalStringCount = 20
            isSecureTextEntry = true
        case .nickname:
            errorMsgAndTypeCheck = .nickname
            inputPlaceHolder = .nickname
            stringCountIsHidden = false
            totalStringCount = 7
        case .authNumber:
            inputPlaceHolder = .authNumber
            authNumberTimer = true //구현하면 false로 바꿔야함 
            authNumberResend = false
        case .profile:
            inputPlaceHolder = .profile
            stringCountIsHidden = false
            totalStringCount = 10
        case .profileKeyword:
            inputPlaceHolder = .profileKeyword
            stringCountIsHidden = false
            totalStringCount = 5
        }
    }
    
}
