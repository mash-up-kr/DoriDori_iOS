//
//  HomeSpeechsRequest.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/20.
//

import Foundation

struct HomeSpeechsReqeust: Requestable {
    var path: String { "/api/v1/posts/near" }
    var parameters: Parameter?
    
    let lastId: String?
    let latitude: Double
    let longitude: Double
    let meterDistance: Double
    let size: Int
    
    init(lastId: String?, latitude: Double, longitude: Double, meterDistance: Double, size: Int) {
        self.lastId = lastId
        self.latitude = latitude
        self.longitude = longitude
        self.meterDistance = meterDistance
        self.size = size
        
        if let lastId = lastId {
            parameters =
                [
                    "lastId" : lastId,
                    "latitude" : latitude,
                    "longitude" : longitude,
                    "meterDistance" : meterDistance,
                    "size" : size
                ]
        } else {
            parameters =
                [
                    "latitude" : latitude,
                    "longitude" : longitude,
                    "meterDistance" : meterDistance,
                    "size" : size
                ]
        }
    }
}
