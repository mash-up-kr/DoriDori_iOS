//
//  UnderLineTextFieldViewModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/30.
//

import Foundation

import Foundation
import UIKit
import RxSwift
import RxCocoa


class UnderLineTextFieldViewModel: ViewModelProtocol {
    
    let inputContentType: UITextContentType
    let returnKeyType: UIReturnKeyType
    let keyboardType: UIKeyboardType
    var isSecureTextEntry: Bool {
        return inputContentType == .password
    }
    var titleLabelType: TextFieldType

    var inputPlaceHolder: TextFieldPlaceHolder = .email
    var errorMessage: TextFieldErrorMessage = .email
    var stringCountIsHidden: Bool = true
    var totalStringCount: Int = 0

    struct Input {
        let inputString: Observable<String>
    }
    
    struct Output {
        let inputIsValid: Observable<Bool>
    }
   
    init() {
        self.titleLabelType = .email
        self.inputContentType = .emailAddress
        self.returnKeyType = .default
        self.keyboardType = .default
    }
    
    init(titleLabelType: TextFieldType,
         inputContentType: UITextContentType = .emailAddress,
         returnKeyType: UIReturnKeyType = .default,
         keyboardType: UIKeyboardType = .default) {

        self.titleLabelType = titleLabelType
        self.inputContentType = inputContentType
        self.returnKeyType = returnKeyType
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
            case .authNumber:
                boolValue = str.authNumberCheck
            case .none:
                return false
            }
            return boolValue
        }
        
        return Output(inputIsValid: validCheckOutput)
    }
    
  

    private func configureTextField(_ type: TextFieldType) {
        switch type {
        case .email:
            errorMessage = .email
            inputPlaceHolder = .email
        case .password:
            errorMessage = .password
            inputPlaceHolder = .password
        case .nickname:
            errorMessage = .nickname
            inputPlaceHolder = .nickname
            stringCountIsHidden = false
            totalStringCount = 7
        case .authNumber:
            errorMessage = .authNumber
            inputPlaceHolder = .authNumber
        }
    }
    
}
