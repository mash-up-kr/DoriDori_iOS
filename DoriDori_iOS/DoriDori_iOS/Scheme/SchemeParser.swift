//
//  SchemeParser.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/20.
//

import Foundation

protocol SchemeParser {
    func parse(data: Any) -> SchemeType?
}

final class URLSchemeParser: SchemeParser {
    func parse(data: Any) -> SchemeType? {
        guard
            let url = data as? URL,
            url.scheme == URLConstant.Scheme.doridori.rawValue,
            let scheme = URLConstant.Scheme(string: url.host)
        else {
                return nil
            }
        
        let path = URLConstant.Path(rawValue: url.path)
        
        switch scheme {
        case .doridori:
            switch path {
            case .question:
                return .question
            case .mypage_other:
                return .mypage_other
            default:
                return nil
            }
        }
    }
}
