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

class UnderLineTextFieldViewModel: ViewModelProtocol {
    
    var inputContentType: UITextContentType = .nickname
    var returnKeyType: UIReturnKeyType = .default
    var keyboardType: UIKeyboardType
    var isSecureTextEntry: Bool {
        return inputContentType == .password
    }
    var titleLabelType: TextFieldType
    var inputPlaceHolder: TextFieldPlaceHolder = .email
    var errorMsgAndTypeCheck: TextFieldErrorMessage = .email
    var stringCountIsHidden: Bool = true
    var totalStringCount: Int = 0
    var authNumberTimer: Bool = true
    var authNumberResend: Bool = true
    
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
    
    struct Input {
        let inputString: Observable<String>
    }
    
    struct Output {
        let inputIsValid: Observable<Bool>
    }
    
    init() {
        self.titleLabelType = .email
        self.inputContentType = .emailAddress
        self.keyboardType = .default
    }
    
    init(titleLabelType: TextFieldType,
         keyboardType: UIKeyboardType = .default) {
        
        self.titleLabelType = titleLabelType
        self.keyboardType = keyboardType
        configureTextField(titleLabelType)
    }
    
    init(titleLabelType: TextFieldType,
         inputContentType: UITextContentType = .emailAddress,
         returnKeyType: UIReturnKeyType = .default,
         keyboardType: UIKeyboardType = .default) {
        
        self.titleLabelType = titleLabelType
        self.inputContentType = inputContentType
        self.keyboardType = keyboardType
        configureTextField(titleLabelType)
    }
    
    func transform(input: Input) -> Output {
        var boolValue: Bool = false
        let validCheckOutput = input.inputString.map { [weak self] str -> Bool in
            if str.isEmpty { return false }
            switch self?.titleLabelType {
            case .email:
                boolValue = str.emailValidCheck
            case .password:
                boolValue = str.passwordValidCheck
            case .nickname:
                boolValue = str.nicknameValidCheck
            case .passwordConfirm, .none:
                break
            case .authNumber:
                boolValue = str.authNumberCheck
            case .none, .profile, .profileKeyword:
                return false
            }
            return boolValue
        }
        
        return Output(inputIsValid: validCheckOutput)
    }
    
    private func configureTextField(_ type: TextFieldType) {
        switch type {
        case .email:
            errorMsgAndTypeCheck = .email
            inputPlaceHolder = .email
        case .password:
            errorMsgAndTypeCheck = .password
            inputPlaceHolder = .password
        case .passwordConfirm:
            errorMsgAndTypeCheck = .password
            inputPlaceHolder = .passwordConfirm
        case .nickname:
            errorMsgAndTypeCheck = .nickname
            inputPlaceHolder = .nickname
            stringCountIsHidden = false
            totalStringCount = 7
        case .authNumber:
            inputPlaceHolder = .authNumber
            authNumberTimer = false
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
