//
//  DealerMOTests.swift
//  YCC ManagerTests
//
//  Created by Vikram Raj Gopinathan on 26/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest
@testable import YCC_Manager

struct DealerData {
    let name: String
    let mobile: String
}

class DealerMOTests: XCTestCase {
    var container: NSPersistentContainer!

    override func setUp() {
        container = NSPersistentContainer.testContainer()
        
        let dealersData = [
            DealerData(name: "Arham Collection", mobile: "7401312003"),
            DealerData(name: "Ambika Jewels", mobile: "9840162078"),
            DealerData(name: "Bhavani Art", mobile: "9677114239"),
            DealerData(name: "Carret 9", mobile: "9909958284"),
            DealerData(name: "Jija Antique", mobile: "9822903008")
        ]
        
        dealersData.forEach { data in
            let dealer = DealerMO(context: self.container.viewContext)
            dealer.name = data.name
            dealer.mobileNumber = data.mobile
        }
        
        try! container.viewContext.save()
    }

    override func tearDown() {
        container = nil
    }

    func testIsDuplicateMobileWhileAdding() {
        let newDealer = DealerMO(context: container.viewContext)
        newDealer.name = "Vikram"
        newDealer.mobileNumber = "9840162078"
        
        let isUnique = try! newDealer.isUnique()
        XCTAssertFalse(isUnique)
    }
    
    func testIsUniqueWhileAdding() {
        let newDealer = DealerMO(context: container.viewContext)
        newDealer.name = "Vikram"
        newDealer.mobileNumber = "9958235698"
        
        let isUnique = try! newDealer.isUnique()
        XCTAssertTrue(isUnique)
    }
    
    func testIsUniqueButDuplicateNameWhileAdding() {
        let newDealer = DealerMO(context: container.viewContext)
        newDealer.name = "Ambika Jewels"
        newDealer.mobileNumber = "9958235698"
        
        let isUnique = try! newDealer.isUnique()
        XCTAssertTrue(isUnique)
    }
    
    func testIsDuplicateWhileUpdating() {
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", "Carret 9")
        fetchRequest.predicate = predicate
        
        let carretDealer = try! container.viewContext.fetch(fetchRequest).first!
        XCTAssertEqual(carretDealer.mobileNumber, "9909958284")
        
        carretDealer.mobileNumber = "9822903008"
        let isUnique = try! carretDealer.isUnique()
        XCTAssertFalse(isUnique)
    }
    
    func testIsUniqueWhileUpdatingTheSameObject() {
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", "Carret 9")
        fetchRequest.predicate = predicate
        
        let carretDealer = try! container.viewContext.fetch(fetchRequest).first!
        XCTAssertEqual(carretDealer.mobileNumber, "9909958284")
        
        carretDealer.mobileNumber = "9909958284"
        
        let isUnique = try! carretDealer.isUnique()
        XCTAssertTrue(isUnique)
    }
    
    func testIsUniqueWhileUpdating() {
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", "Carret 9")
        fetchRequest.predicate = predicate
        
        let carretDealer = try! container.viewContext.fetch(fetchRequest).first!
        XCTAssertEqual(carretDealer.mobileNumber, "9909958284")
        
        carretDealer.mobileNumber = "9871318150"
        
        let isUnique = try! carretDealer.isUnique()
        XCTAssertTrue(isUnique)
    }
    
    func testIsUniqueWhileNameDuplicateWhileUpdating() {
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", "Carret 9")
        fetchRequest.predicate = predicate
        
        let carretDealer = try! container.viewContext.fetch(fetchRequest).first!
        XCTAssertEqual(carretDealer.mobileNumber, "9909958284")
        
        carretDealer.name = "Ambika Jewels"
        
        let isUnique = try! carretDealer.isUnique()
        XCTAssertTrue(isUnique)
    }
}
