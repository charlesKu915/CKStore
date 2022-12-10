//
//  DeviceStoreValue.swift
//  CKStore
//
//  Created by charles on 2022/2/9.
//

import Foundation
import Combine

@propertyWrapper
public class DeviceStoreValue<Value, DS: DeviceStore> {
    
    public private(set) var key: String
    
    private let deviceStore: DS
    
    private var defaultValue: Value
    
    public var wrappedValue: Value {
        get { deviceStore.getValue(for: key) ?? defaultValue }
        set { deviceStore.updateValue(value: newValue, for: key) }
    }
    
    public init(key: String, deviceStore: DS, defaultValue: Value) {
        self.key = key
        self.deviceStore = deviceStore
        self.defaultValue = defaultValue
    }
    
    public convenience init<T: RawRepresentable>(keyRawPresentable: T, deviceStore: DS, defaultValue: Value) where T.RawValue == String {
        self.init(key: keyRawPresentable.rawValue, deviceStore: deviceStore, defaultValue: defaultValue)
    }
    
    public func updateKey(with key: String) {
        self.key = key
    }
    
    public func updateKey(by stringPresentable: StringPresentable) {
        self.key = stringPresentable.string
    }
    
}

@propertyWrapper
public class PublishedDeviceStoreValue<Value, DS: DeviceStore> {
    
    public private(set) var key: String
    
    private let deviceStore: DS
    
    private var defaultValue: Value
    
    private let valueSubject = PassthroughSubject<Value, Never>()
    
    public var wrappedValue: Value {
        get {
            deviceStore.getValue(for: key) ?? defaultValue
        }
        set {
            deviceStore.updateValue(value: newValue, for: key)
            valueSubject.send(newValue)
        }
    }
    
    public var projectedValue: AnyPublisher<Value, Never> {
        valueSubject.eraseToAnyPublisher()
    }
    
    public init(key: String, deviceStore: DS, defaultValue: Value) {
        self.key = key
        self.deviceStore = deviceStore
        self.defaultValue = defaultValue
    }
    
    public convenience init<T: RawRepresentable>(keyRawPresentable: T, deviceStore: DS, defaultValue: Value) where T.RawValue == String {
        self.init(key: keyRawPresentable.rawValue, deviceStore: deviceStore, defaultValue: defaultValue)
    }
    
    public func updateKey(with key: String) {
        self.key = key
    }
    
    public func updateKey(by stringPresentable: StringPresentable) {
        self.key = stringPresentable.string
    }
    
}


@propertyWrapper
public class DeviceStoreObject<Object: Codable, DS: DeviceStore> {
    
    public private(set) var key: String
    
    private let deviceStore: DS
    
    private var defaultValue: Object
    
    public var wrappedValue: Object {
        get {
            let jsonDecoder = JSONDecoder()
            guard let data: Data = deviceStore.getValue(for: key),
                  let object = try? jsonDecoder.decode(Object.self, from: data)
            else { return defaultValue }
            return object
        }
        set {
            let jsonEncoder = JSONEncoder()
            let data = try? jsonEncoder.encode(newValue)
            deviceStore.updateValue(value: data, for: key)
        }
    }
    
    public init(key: String, deviceStore: DS, defaultValue: Object) {
        self.key = key
        self.deviceStore = deviceStore
        self.defaultValue = defaultValue
    }
    
    public convenience init<T: RawRepresentable>(keyRawPresentable: T, deviceStore: DS, defaultValue: Object) where T.RawValue == String {
        self.init(key: keyRawPresentable.rawValue, deviceStore: deviceStore, defaultValue: defaultValue)
    }
    
    public func updateKey(with key: String) {
        self.key = key
    }
    
    public func updateKey(by stringPresentable: StringPresentable) {
        self.key = stringPresentable.string
    }
    
}


@propertyWrapper
public class PublishedDeviceStoreObject<Object: Codable, DS: DeviceStore> {
    
    public private(set) var key: String
    
    private let deviceStore: DS
    
    private var defaultValue: Object
    
    private let objectSubject = PassthroughSubject<Object, Never>()
    
    public var wrappedValue: Object {
        get {
            let jsonDecoder = JSONDecoder()
            guard let data: Data = deviceStore.getValue(for: key),
                  let object = try? jsonDecoder.decode(Object.self, from: data)
            else { return defaultValue }
            return object
        }
        set {
            let jsonEncoder = JSONEncoder()
            let data = try? jsonEncoder.encode(newValue)
            deviceStore.updateValue(value: data, for: key)
            objectSubject.send(newValue)
        }
    }
    
    public var projectedValue: AnyPublisher<Object, Never> {
        objectSubject.eraseToAnyPublisher()
    }
    
    public init(key: String, deviceStore: DS, defaultValue: Object) {
        self.key = key
        self.deviceStore = deviceStore
        self.defaultValue = defaultValue
    }
    
    public convenience init<T: RawRepresentable>(keyRawPresentable: T, deviceStore: DS, defaultValue: Object) where T.RawValue == String {
        self.init(key: keyRawPresentable.rawValue, deviceStore: deviceStore, defaultValue: defaultValue)
    }
    
    public func updateKey(with key: String) {
        self.key = key
    }
    
    public func updateKey(by stringPresentable: StringPresentable) {
        self.key = stringPresentable.string
    }
    
}
