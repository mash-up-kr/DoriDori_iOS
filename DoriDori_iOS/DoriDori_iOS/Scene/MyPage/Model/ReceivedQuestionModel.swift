//
//  ReceivedQuestionModel.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/30.
//

import Foundation

struct ReceivedQuestionModel: Codable {
    var hasNext: Bool?
    var questions: [QuestionModel]?
}
