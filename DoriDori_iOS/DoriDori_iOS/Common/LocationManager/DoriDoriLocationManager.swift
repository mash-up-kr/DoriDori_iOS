//
//  DoriDoriLocationManager.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/22.
//

import Foundation
import CoreLocation
import RxSwift

final class DoriDoriLocationManager: NSObject,
                                     LocationManager {
    private let location: CLLocationManager
    private var completionHander: ((Result<Location, DoriDoriLocationError>) -> Void)?
     
    init(
        location: CLLocationManager = .init()
    ) {
        self.location = location
        super.init()
        self.location.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    func getLocation() -> Observable<Result<Location, DoriDoriLocationError>> {
        let status = CLLocationManager.authorizationStatus()
        
        let locationOb: Observable<Result<Location, DoriDoriLocationError>> = self.location.rx.didUpdateLocations
            .compactMap { $0.last?.coordinate }
            .map { (latitude: $0.latitude, longitude: $0.longitude) }
            .map { .success($0) }
        
        let errorOb: Observable<Result<Location, DoriDoriLocationError>> = Observable.merge(
            self.location.rx.didFailWithError,
            self.location.rx.didFinishDeferredUpdatesWithError
        )
        .map { .failure($0) }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.location.startUpdatingLocation()
        case .denied, .notDetermined:
            self.location.requestWhenInUseAuthorization()
            self.location.startUpdatingLocation()
        default: break
        }
        
        return Observable.merge(locationOb, errorOb)
    }
    
}
