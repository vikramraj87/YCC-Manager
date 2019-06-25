//
//  TagMO+CoreDataProperties.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 23/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//
//

import Foundation
import CoreData


extension TagMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagMO> {
        return NSFetchRequest<TagMO>(entityName: "Tag")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var tag: String
    @NSManaged public var jewels: NSSet?

}

// MARK: Generated accessors for jewels
extension TagMO {

    @objc(addJewelsObject:)
    @NSManaged public func addToJewels(_ value: Jewel)

    @objc(removeJewelsObject:)
    @NSManaged public func removeFromJewels(_ value: Jewel)

    @objc(addJewels:)
    @NSManaged public func addToJewels(_ values: NSSet)

    @objc(removeJewels:)
    @NSManaged public func removeFromJewels(_ values: NSSet)

}
