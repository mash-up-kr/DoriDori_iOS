//
//  SchemeExecuter.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/20.
//

import Foundation

struct SchemeExecuter {
    private let schemeType: SchemeType
    
    init(schemeType: SchemeType) {
        self.schemeType = schemeType
    }
    
    func execute() {
        switch schemeType {
        case .question:
            print("QUESTION")
        case .mypage_other:
            print("MYPAGE_OTHER")
        }
    }
}
