//
//  DealerMO+CoreDataClass.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 26/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//
//

import Foundation
import CoreData


public class DealerMO: NSManagedObject {
    public override func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: "createdAt")
    }
    
    static var nameSortedFetchRequest: NSFetchRequest<DealerMO> {
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \DealerMO.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}


