//
//  StorageContainer.swift
//  CKStore
//
//  Created by charles on 2022/2/9.
//

import Foundation
import CoreData
import CloudKit

public class StorageContainer {
    
    public struct CoreDataSettings {
        let definitionUrl: URL
        let name: String
    }

    public private(set) lazy var local: NSPersistentContainer = {
        guard let model = NSManagedObjectModel(contentsOf: coreDataSettings.definitionUrl) else {
            fatalError("Load Model failed")
        }

        let container = PersistentContainer(name: coreDataSettings.name, managedObjectModel:model)
        container.persistentStoreDescriptions = [
            NSPersistentStoreDescription(url: localSqlLitePath)
        ]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var localSqlLitePath: URL {
        guard let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        let currentFolder = docUrl.appendingPathComponent(identifier, isDirectory: true)

        if !FileManager.default.fileExists(atPath: currentFolder.path) {
            try? FileManager.default.createDirectory(at: currentFolder, withIntermediateDirectories: true, attributes: nil)
        }
        return currentFolder.appendingPathComponent("model.sqlite")
    }
    
    public private(set) var cloud: CKContainer
    
    public let identifier: String
    
    private let coreDataSettings: CoreDataSettings
    
    public init(
        identifier: String,
        coreDataSettings: CoreDataSettings
    ) {
        self.identifier = identifier
        self.coreDataSettings = coreDataSettings
        self.cloud = CKContainer(identifier: identifier)
    }

}
