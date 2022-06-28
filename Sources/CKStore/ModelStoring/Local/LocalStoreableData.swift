//
//  LocalStoreableModel.swift
//  BeetleDiaryCore
//
//  Created by charles on 2022/5/15.
//

import Foundation
import CoreData

public protocol LocalStoreableModel: Equatable {
    
    associatedtype Object: CoreDataObject where Object.Presenter == Self

    var idString: String { get }
    
    init?(obj: Object)
    
    @discardableResult
    func makeObject(in context: NSManagedObjectContext) -> Object
    
}

extension LocalStoreableModel {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.idString == rhs.idString
    }
    
}
