//
//  Scheme.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/20.
//

import Foundation
import RxSwift

final class Scheme {
    static func open(data: Any) {
        guard let schemeType = URLSchemeParser().parse(data: data) else {
            return
        }
        let executer = SchemeExecuter(schemeType: schemeType)
        executer.execute()
    }
}

