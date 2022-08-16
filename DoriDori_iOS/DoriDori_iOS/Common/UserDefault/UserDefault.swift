//
//  UserDefault.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/17.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let container: UserDefaults
    private let key: String
    private let defaultValue: T

    var wrappedValue: T {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            return container.set(newValue, forKey: key)
        }
    }

    init(key: String, defaultValue: T) {
        container = .standard
        self.key = key
        self.defaultValue = defaultValue
    }
}
