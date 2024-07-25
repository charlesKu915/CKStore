//
//  CoreDataObject.swift
//  CKStore
//
//  Created by charles on 2022/5/15.
//

import Foundation
import CoreData

public protocol CoreDataObject: NSManagedObject{
    
    associatedtype Presenter: LocalStoreableModel where Presenter.Object == Self
    
    static var entityName: String { get }
    
    var idString: String? { get }
    
    var createdAt: Date? { get }
    
    var modifiedAt: Date? { get }
    
    func updateValues(with storeable: Presenter)
    
}

public extension CoreDataObject {
    
    static func fetch<O: NSFetchRequestResult>(request: NSFetchRequest<O>, in viewContext: NSManagedObjectContext) async -> [O] {
        await viewContext.perform { () -> [O] in
            let result = try? viewContext.fetch(request)
            return result ?? []
        }
    }
    
    static func fetchDistincValue<O>(fieldName: String, in viewContext: NSManagedObjectContext) async -> [O] {
        await fetch(
            request: {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let description = NSEntityDescription.entity(forEntityName: entityName, in: viewContext)!
                request.resultType = .dictionaryResultType
                request.propertiesToFetch = [description.propertiesByName[fieldName]!]
                request.returnsDistinctResults = true
                return request
            }(),
            in: viewContext
        ).compactMap {
            guard let dic = $0 as? [String: Any],
                  let value = dic[fieldName] as? O
            else {
                return nil
            }
            return value
        }
    }
    
    static func fetchLastModifiedDate(in viewContext: NSManagedObjectContext) async -> Date? {
        await fetchDistincValue(fieldName: "modifiedAt", in: viewContext).sorted(by: >).first
    }
    
    static func fetchObject(withIdentifier identifier: String, in viewContext: NSManagedObjectContext) async -> Self? {
        await fetch(
            request: {
                let predicate = NSPredicate(format: "identifier == %@", identifier)
                let request = Self.fetchRequest()
                request.predicate = predicate
                return request
            }(),
            in: viewContext
        ).first as? Self
    }
    
    static func findObjects(withIdentifiersIn idArray: [String], in viewContext: NSManagedObjectContext) async -> [Self] {
        await fetch(
            request: {
                let predicate = NSPredicate(format: "identifier In %@", idArray)
                let request = Self.fetchRequest()
                request.predicate = predicate
                return request
            }(),
            in: viewContext
        ) as? [Self] ?? []
    }
    
    static func fetchAllObjects(in viewContext: NSManagedObjectContext) async -> [Self] {
        await fetch(
            request: self.fetchRequest(),
            in: viewContext
        ) as? [Self] ?? []
    }
    
}
