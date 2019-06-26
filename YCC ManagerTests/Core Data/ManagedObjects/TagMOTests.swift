//
//  TagMOTests.swift
//  YCC ManagerTests
//
//  Created by Vikram Raj Gopinathan on 26/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest

@testable import YCC_Manager

class TagMOTests: XCTestCase {
    var container: NSPersistentContainer!

    override func setUp() {
        container = NSPersistentContainer.testContainer()
        
        ["Bangle",
         "Earring",
         "Jhumkha"].forEach { tagName in
            let tagObj = TagMO(context: self.container.viewContext)
            tagObj.tag = tagName
        }
        
        try! container.viewContext.save()
    }

    override func tearDown() {
        container = nil
    }
    
    // MARK: - isUnique() tests
    func testDuplicateEntryIsNotUniqueWhileAdding() {
        let newTag = TagMO(context: container.viewContext)
        newTag.tag = "Bangle"
        
        let isUnique = try! newTag.isUnique()
        XCTAssertFalse(isUnique)
    }
    
    func testDuplicateEntryCaseInsensitiveWhileAdding() {
        let newTag = TagMO(context: container.viewContext)
        newTag.tag = "bangle"
        
        let isUnique = try! newTag.isUnique()
        XCTAssertFalse(isUnique)
    }
    
    func testUniqueItemWhileAdding() {
        let newTag = TagMO(context: container.viewContext)
        newTag.tag = "Tikka"
        
        let isUnique = try! newTag.isUnique()
        XCTAssertTrue(isUnique)
    }
    
    func testDuplicateEntryWhileUpdating() {
        let fetchRequest: NSFetchRequest<TagMO> = TagMO.fetchRequest()
        let predicate = NSPredicate(format: "tag ==[c] %@", "bangle")
        fetchRequest.predicate = predicate
        
        let bangleTag = try! container.viewContext.fetch(fetchRequest).first!
        XCTAssertEqual("Bangle", bangleTag.tag)
        
        bangleTag.tag = "earring"
        let isUnique = try! bangleTag.isUnique()
        XCTAssertFalse(isUnique)
    }
    
    func testUniqueEntryWhileUpdating() {
        let fetchRequest: NSFetchRequest<TagMO> = TagMO.fetchRequest()
        let predicate = NSPredicate(format: "tag ==[c] %@", "bangle")
        fetchRequest.predicate = predicate
        
        let bangleTag = try! container.viewContext.fetch(fetchRequest).first!
        XCTAssertEqual("Bangle", bangleTag.tag)
        
        bangleTag.tag = "Valaiyal"
        let isUnique = try! bangleTag.isUnique()
        XCTAssertTrue(isUnique)
    }

}
