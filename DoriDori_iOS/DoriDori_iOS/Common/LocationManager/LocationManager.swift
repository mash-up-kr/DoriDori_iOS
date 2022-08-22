//
//  LocationManager.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/22.
//

import Foundation
import CoreLocation
import RxSwift

enum DoriDoriLocationError: LocalizedError {
    case noData
    case unknownError
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .noData: return "위도,경도 정보가 없습니다"
        case .unknownError: return "위치를 불러오는데 알 수 없는 에러가 발생했습니다"
        case .timeout: return "위치를 불러오는데 시간이 초과되었습니다."
        }
    }
}

final class LocationManager: NSObject {
    private let location: CLLocationManager
    private var completionHander: ((Result<Location, DoriDoriLocationError>) -> Void)?
     
    init(
        location: CLLocationManager = .init()
    ) {
        self.location = location
        super.init()
//        self.location.delegate = self
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
            print("🍀위치정보 허용되어있음")
            self.location.startUpdatingLocation()
        case .denied, .notDetermined:
            print("🍀위치정보 허용안되어있음")
            self.location.requestWhenInUseAuthorization()
            self.location.startUpdatingLocation()
        default: break
        }
        
        return Observable.merge(locationOb, errorOb)
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        self.completionHander?(.failure(DoriDoriLocationError.unknownError))
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if locations.isEmpty {
            self.completionHander?(.failure(DoriDoriLocationError.noData))
            return
        }
        guard let currentCoordinator = locations.last?.coordinate else { return }
        let location: Location = (longitude: currentCoordinator.longitude, latitude: currentCoordinator.latitude)
        self.completionHander?(.success(location))
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFinishDeferredUpdatesWithError error: Error?
    ) {
        self.completionHander?(.failure(DoriDoriLocationError.timeout))
    }
}
