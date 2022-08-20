//
//  URLContant.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/20.
//

import Foundation

struct URLConstant {
    enum Scheme: String {
        case doridori
        
        init?(string: String?) {
            guard let rawValue = string?.lowercased() else {
                return nil
            }
            self.init(rawValue: rawValue)
        }
    }
    
    enum Path: String {
        case question = "/question"
        case mypage_other = "/mypage_other"
    }
}

enum SchemeType {
    case question
    case mypage_other
}
