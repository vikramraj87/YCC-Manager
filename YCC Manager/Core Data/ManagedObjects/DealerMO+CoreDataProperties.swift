//
//  DealerMO+CoreDataProperties.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 26/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//
//

import Foundation
import CoreData


extension DealerMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DealerMO> {
        return NSFetchRequest<DealerMO>(entityName: "Dealer")
    }

    @NSManaged public var codeMultiplicationFactor: Float
    @NSManaged public var createdAt: Date
    @NSManaged public var mobileNumber: String
    @NSManaged public var name: String
    @NSManaged public var jewels: NSSet?

}

// MARK: Generated accessors for jewels
extension DealerMO {

    @objc(addJewelsObject:)
    @NSManaged public func addToJewels(_ value: Jewel)

    @objc(removeJewelsObject:)
    @NSManaged public func removeFromJewels(_ value: Jewel)

    @objc(addJewels:)
    @NSManaged public func addToJewels(_ values: NSSet)

    @objc(removeJewels:)
    @NSManaged public func removeFromJewels(_ values: NSSet)

}
