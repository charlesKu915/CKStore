//
//  LocalDeviceStore.swift
//  CKStore
//
//  Created by charles on 2022/2/9.
//

import Foundation

extension UserDefaults: KeyValueStore { }

public class LocalDeviceStore: DeviceStore {
    
    public static let standard = LocalDeviceStore(store: .standard)
        
    public let store: UserDefaults
    
    public init(store: UserDefaults) {
        self.store = store
    }
    
}
