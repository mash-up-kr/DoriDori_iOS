//
//  CLLocationManger+Rx.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/23.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

class RxCLLocationManagerDelegateProxy:
    DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
        DelegateProxyType,
        CLLocationManagerDelegate {

    init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }

    fileprivate var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    fileprivate var didFailWithErrorSubject = PublishSubject<DoriDoriLocationError>()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
        didUpdateLocationsSubject.onNext(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(DoriDoriLocationError.unknownError)
    }

    deinit {
        self.didUpdateLocationsSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
}



extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        RxCLLocationManagerDelegateProxy.proxy(for: base)
    }

    var didUpdateLocations: Observable<[CLLocation]> {
        RxCLLocationManagerDelegateProxy.proxy(for: base).didUpdateLocationsSubject.asObservable()
    }
    var didFailWithError: Observable<DoriDoriLocationError> {
        RxCLLocationManagerDelegateProxy.proxy(for: base).didFailWithErrorSubject.asObservable()
            .map { _ in return DoriDoriLocationError.unknownError}
    }
    var didFinishDeferredUpdatesWithError: Observable<DoriDoriLocationError> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFinishDeferredUpdatesWithError:)))
            .map { _ in return DoriDoriLocationError.timeout }
    }
}
