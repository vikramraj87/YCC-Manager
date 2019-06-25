//
//  TagMO+CoreDataClass.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 23/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//
//

import Foundation
import CoreData


public class TagMO: NSManagedObject {
    public override func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: "createdAt")
    }
}
