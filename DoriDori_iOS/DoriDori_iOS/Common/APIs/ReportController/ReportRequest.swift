//
//  ReportRequest.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/09/18.
//

import Foundation

enum ReportType {
    case post
    case question
    case answer
    case comment
}

struct ReportRequest: Requestable {
    var path: String { "/api/v1/report/\(type)/\(targetID)" }
    var parameters: Parameter? { nil }
    var method: HTTPMethod { .post }
    private let type: ReportType
    private let targetID: String
    
    
    init(
        type: ReportType,
        targetID: String
    ) {
        self.type = type
        self.targetID = targetID
    }
}
