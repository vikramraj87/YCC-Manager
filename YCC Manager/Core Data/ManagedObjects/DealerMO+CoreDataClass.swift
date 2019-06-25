//
//  DealerMO+CoreDataClass.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 18/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DealerMO)
public class DealerMO: NSManagedObject {
    public override func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: "createdAt")
    }
}
