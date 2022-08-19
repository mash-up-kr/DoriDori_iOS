//
//  String+Extenstion.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/19.
//

import Foundation

extension String {
    var emailValidCheck: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
            
    var passwordValidCheck: Bool {
        let passwordreg = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,20}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return predicate.evaluate(with: self)
    }
    
    var nicknameValidCheck: Bool {
        //한글영어특수문자 상관없이 띄어쓰기 포함 7자이하
        let nicknamereg = "^[a-zA-Z0-9가-힣 `~!@#$%^&*()\\-_=+\\[{\\]}\\\\|;:'\",<.>/?//s]{1,7}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknamereg)
        return predicate.evaluate(with: self)
    }
    
    var authNumberCheck: Bool {
        //인증번호 받아서 맞는지 체크
        return false
    }
}
