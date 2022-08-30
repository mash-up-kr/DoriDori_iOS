//
//  TermsOfServiceModel.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/23.
//

import Foundation

struct TermsModel: Codable {
    var id: String
    var title: String
    var content: String
    var necessary: Bool
}
