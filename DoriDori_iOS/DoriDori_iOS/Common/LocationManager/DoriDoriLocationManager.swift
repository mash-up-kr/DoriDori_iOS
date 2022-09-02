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
            .compactMap(\.last?.coordinate)
            .map { (latitude: $0.latitude, longitude: $0.longitude) }
            .do(onNext: { print("😲", $0) })
            .map { .success($0) }
        
        let errorOb1: Observable<Result<Location, DoriDoriLocationError>> = Observable.merge(
            self.location.rx.didFailWithError,
            self.location.rx.didFinishDeferredUpdatesWithError
        )
        .do(onNext: { print("🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔", $0)})
        .map { .failure($0) }
        
  
        let errorOb: Observable<Result<Location, DoriDoriLocationError>>
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("🤔🤔🤔")
            self.location.startUpdatingLocation()
            errorOb = Observable<Result<Location, DoriDoriLocationError>>.create { observer in
                return Disposables.create()
            }
        case .denied, .restricted:
            print("🤔")
            self.location.requestWhenInUseAuthorization()
//            self.location.startUpdatingLocation()
            errorOb = Observable<Result<Location, DoriDoriLocationError>>.create { observer in
                observer.onNext(.failure(DoriDoriLocationError.unknownError))
                return Disposables.create()
            }
        case .notDetermined:
            print("🤔🤔")
            self.location.requestWhenInUseAuthorization()
            self.location.startUpdatingLocation()
            errorOb = Observable<Result<Location, DoriDoriLocationError>>.create { observer in
                return Disposables.create()
            }
        default:
            print("🤔🤔🤔🤔")
            errorOb = Observable<Result<Location, DoriDoriLocationError>>.create { observer in
                return Disposables.create()
            }
        }
        
        return Observable.merge(locationOb, errorOb, errorOb1)
    }
    
}
