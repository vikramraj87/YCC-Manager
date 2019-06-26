//
//  DuplicateChecker.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 25/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation
import CoreData

enum UniqueObjectError: Error {
    case cannotFetchContext
}

protocol UniqueObject {
    var uniquePredicate: NSPredicate { get }
    
    func isUnique() throws -> Bool
}

extension UniqueObject where Self: NSManagedObject {
    func isUnique() throws -> Bool {
        guard let context = managedObjectContext else {
            throw UniqueObjectError.cannotFetchContext
        }
        
        let excludeSelfPredicate = NSPredicate(format: "NOT (SELF == %@)", self)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            uniquePredicate,
            excludeSelfPredicate
        ])
        
        let fetchRequest: NSFetchRequest<Self> = Self.fetchRequest() as! NSFetchRequest<Self>
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .countResultType
        
        let fetchObjectsCount = try context.count(for: fetchRequest)
        
        return fetchObjectsCount == 0
    }
}
