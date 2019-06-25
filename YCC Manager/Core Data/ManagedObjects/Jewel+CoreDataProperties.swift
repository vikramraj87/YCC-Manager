//
//  Jewel+CoreDataProperties.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 23/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//
//

import Foundation
import CoreData


extension Jewel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Jewel> {
        return NSFetchRequest<Jewel>(entityName: "Jewel")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var dealer: DealerMO?
    @NSManaged public var images: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for images
extension Jewel {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Jewel {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagMO)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagMO)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
