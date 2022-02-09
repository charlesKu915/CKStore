//
//  CrossDeviceStore.swift
//  CKStore
//
//  Created by charles on 2022/2/9.
//

import Foundation

extension NSUbiquitousKeyValueStore: KeyValueStore { }

public class CrossDeviceStore: DeviceStore {
    
    public static let `default` = CrossDeviceStore(store: NSUbiquitousKeyValueStore.default)
    
    public let store: NSUbiquitousKeyValueStore
    
    init(store: NSUbiquitousKeyValueStore) {
        self.store = store
    }
    
}
