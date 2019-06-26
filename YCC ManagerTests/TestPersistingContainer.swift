//
//  TestPersistingContainer.swift
//  YCC ManagerTests
//
//  Created by Vikram Raj Gopinathan on 26/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    class func testContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "YCCData")
        
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { (description, error) in
            print(description)
            if let error = error {
                fatalError("\(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }
}
