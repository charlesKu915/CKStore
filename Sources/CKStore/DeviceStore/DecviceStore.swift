//
//  DecviceStore.swift
//  CKStore
//
//  Created by Charles on 2022/2/9.
//

import Foundation

public protocol StringPresentable {
    
    var string: String { get }
    
}

extension String: StringPresentable {
    
    public var string: String { self }
    
}

public protocol KeyValueStore {
    
    func object(forKey aKey: String) -> Any?

    func set(_ anObject: Any?, forKey aKey: String)
    
    @discardableResult func synchronize() -> Bool
    
}

public protocol DeviceStore {
    
    associatedtype BaseStorage: KeyValueStore
    
    var store: BaseStorage { get }
    
    func getValue<O>(for stringPresentableKey: StringPresentable) -> O?
    
    func updateValue(value: Any?, for stringPresentableKey: StringPresentable)
    
    func getValue<T: RawRepresentable, O>(for rawStringPresentableKey: T) -> O? where T.RawValue == String
    
    func updateValue<T: RawRepresentable>(value: Any?, for rawStringPresentableKey: T) where T.RawValue == String
    
}

public extension DeviceStore {
    
    func getValue<O>(for stringPresentableKey: StringPresentable) -> O? {
        store.object(forKey: stringPresentableKey.string) as? O
    }
    
    func updateValue(value: Any?, for stringPresentableKey: StringPresentable) {
        store.set(value, forKey: stringPresentableKey.string)
        store.synchronize()
    }
    
    func getValue<T: RawRepresentable, O>(for rawStringPresentableKey: T) -> O? where T.RawValue == String {
        store.object(forKey: rawStringPresentableKey.rawValue) as? O
    }
    
    func updateValue<T: RawRepresentable>(value: Any?, for rawStringPresentableKey: T) where T.RawValue == String {
        store.set(value, forKey: rawStringPresentableKey.rawValue)
        store.synchronize()
    }
    
}
