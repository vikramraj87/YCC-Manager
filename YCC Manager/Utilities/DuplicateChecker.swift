//
//  DuplicateChecker.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 26/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation
import CoreData

class DuplicateChecker<T: NSManagedObject> {
    let context: NSManagedObjectContext
    let predicateFormat: String
    
    init(context: NSManagedObjectContext, predicateFormat: String) {
        self.context = context
        self.predicateFormat = predicateFormat
    }
    
    public func isDuplicateValue(_ value: String, objectUpdated: T?) throws -> Bool {
        // Configure predicate by field
        var predicate = NSPredicate(format: predicateFormat, value)
        if let object = objectUpdated {
            // Exclude the object to be updated
            let objectPredicte = NSPredicate(format: "NOT (SELF == %@)", object)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                predicate,
                objectPredicte
                ])
        }
        
        // Configure fetch request to find duplicate
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .countResultType
        
        // Fetch count of duplicate objects
        let fetchedObjectsCount = try context.count(for: fetchRequest)
        
        return fetchedObjectsCount > 0
    }
}
