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
            url.scheme == URLConstant.Host.doridori.rawValue,
            let scheme = URLConstant.Scheme(string: url.host)
        else {
            return nil
        }
        
        let path = URLConstant.Path(rawValue: url.path)
        
        let userIdDict: [String: String] = parseQuery(url.query ?? "", key: "userId")
        let userId = userIdDict["userId"]
        
        
        switch scheme {
        case .main:
            switch path {
            case .question:
                return .question(userId: userId)
            case .mypage_other:
                return .mypage_other
            default:
                return nil
            }
        }
    }
    
    private func parseQuery(_ query: String, key: String) -> [String: String] {
        let parameters = query.components(separatedBy: "&")
        var result  = [String: String]()
        
        for param in parameters {
            let union = param.components(separatedBy: "=")
            
            guard
                union.count == 2,
                let key = union.first,
                let value = union.last
            else {
                continue
            }
            
            result[key] = value
        }
        return result
    }
}
