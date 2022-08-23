//
//  LocationManager.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/23.
//

import Foundation
import RxSwift

typealias Location = (longitude: Double, latitude: Double)

protocol LocationManager: AnyObject {
    func getLocation() -> Observable<Result<Location, DoriDoriLocationError>>
}
