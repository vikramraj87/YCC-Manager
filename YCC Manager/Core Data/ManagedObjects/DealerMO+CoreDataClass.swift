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
}

extension DealerMO: UniqueObject {
    var uniquePredicate: NSPredicate {
        return NSPredicate(format: "mobileNumber ==[c] %@", self.mobileNumber)
    }
}
