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
    
    var idString: String? { get }
    
    var createdAt: Date? { get }
    
    var modifiedAt: Date? { get }
    
    func updateValues(with storeable: Presenter)
    
}
