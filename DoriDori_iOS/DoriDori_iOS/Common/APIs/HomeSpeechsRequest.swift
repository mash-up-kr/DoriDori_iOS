//
//  HomeSpeechsRequest.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/20.
//

import Foundation

struct HomeSpeechsReqeust: Requestable {
    var path: String { "/api/v1/posts/near" }
    var parameters: Parameter? {
        [
            "lastId" : lastId,
            "latitude" : latitude,
            "longitude" : longitude,
            "meterDistance" : meterDistance,
            "size" : size
        ]
    }
    
    let lastId: String
    let latitude: Double
    let longitude: Double
    let meterDistance: Double
    let size: Int
}
