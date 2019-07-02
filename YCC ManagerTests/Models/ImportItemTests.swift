//
//  ImportItemTests.swift
//  YCC ManagerTests
//
//  Created by Vikram Raj Gopinathan on 14/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest
import CoreData

@testable import YCC_Manager

class ImportItemTests: XCTestCase {
    var item1: ImportItem!
    var item2: ImportItem!
    var item3: ImportItem!
    var item4: ImportItem!
    
    let url1 = URL(fileURLWithPath: "/home/jewel1.jpg")
    let url2 = URL(fileURLWithPath: "/home/jewel2.jpg")
    let url3 = URL(fileURLWithPath: "/home/jewel3.jpg")
    let url4 = URL(fileURLWithPath: "/home/jewel4.jpg")
    let url5 = URL(fileURLWithPath: "/home/jewel5.jpg")
    let url6 = URL(fileURLWithPath: "/home/jewel6.jpg")
    
    var container: NSPersistentContainer!
    
    var tag1: TagMO!
    var tag2: TagMO!
    var tag3: TagMO!
    var tag4: TagMO!
    var tag5: TagMO!
    var tag6: TagMO!
    var tagUno: TagMO!
    var tagDio: TagMO!
    var tagTrio: TagMO!
    
    override func setUp() {
        item1 = ImportItem(imageURL: url1)
        item2 = ImportItem(imageURL: url2)
        item3 = ImportItem(imageURL: url3)
        item4 = ImportItem(imageURLs: [url4, url5, url6])
        
        container = NSPersistentContainer.testContainer()
        
        tag1 = TagMO(context: container.viewContext)
        tag2 = TagMO(context: container.viewContext)
        tag3 = TagMO(context: container.viewContext)
        tag4 = TagMO(context: container.viewContext)
        tag5 = TagMO(context: container.viewContext)
        tag6 = TagMO(context: container.viewContext)
        tagUno = TagMO(context: container.viewContext)
        tagDio = TagMO(context: container.viewContext)
        tagTrio = TagMO(context: container.viewContext)
        
        tag1.tag = "One"
        tag2.tag = "Two"
        tag3.tag = "Three"
        tag4.tag = "Four"
        tag5.tag = "Five"
        tag6.tag = "Six"
        tagUno.tag = "Uno"
        tagDio.tag = "Dio"
        tagTrio.tag = "Trio"
        
        try! container.viewContext.save()
    }

    func testHasMultipleImages() {
        XCTAssertTrue(item4.hasMultipleImages)
        XCTAssertFalse(item1.hasMultipleImages)
        XCTAssertFalse(item2.hasMultipleImages)
        XCTAssertFalse(item3.hasMultipleImages)
    }
    
    func testContains() {
        XCTAssertTrue(item1.contains(url1))
        XCTAssertTrue(item2.contains(url2))
        XCTAssertTrue(item3.contains(url3))
        XCTAssertTrue(item4.contains(url4))
        XCTAssertTrue(item4.contains(url5))
        XCTAssertTrue(item4.contains(url6))
        
        XCTAssertFalse(item1.contains(url2))
        XCTAssertFalse(item2.contains(url3))
        XCTAssertFalse(item3.contains(url4))
        XCTAssertFalse(item4.contains(url1))
        XCTAssertFalse(item4.contains(url2))
        XCTAssertFalse(item4.contains(url3))
    }
    
    func testMergeWithSingleURLItems() {
        item1.tags = [tag1, tag2, tag3]
        item2.tags = [tag3, tag4, tag5]
        item3.tags = [tag4, tag5, tag6]
        
        item1.merge(with: [item2, item3])
        XCTAssertEqual(item1.imageURLs, [url1, url2, url3])
        XCTAssertEqual(item1.tags, [tag1, tag2, tag3])
    }
    
    func testMergeWithMultipleURLItems() {
        item1.tags = [tag1, tag2, tag3]
        item4.tags = [tag4, tag5, tag6]
        
        item1.merge(with: [item4])
        XCTAssertEqual(item1.imageURLs, [url1, url4, url5, url6])
        XCTAssertEqual(item1.tags, [tag1, tag2, tag3])
    }
    
    func testUnmerge() {
        item4.tags = [tag4, tag5, tag6]
        
        let unmergedItems = item4.unmerge()
        XCTAssertEqual(item4.imageURLs, [url4])
        XCTAssertEqual(unmergedItems[0].imageURLs, [url5])
        XCTAssertEqual(unmergedItems[1].imageURLs, [url6])
        
        XCTAssertEqual(item4.tags, [tag4, tag5, tag6])
        XCTAssertEqual(unmergedItems[0].tags, [tag4, tag5, tag6])
        XCTAssertEqual(unmergedItems[1].tags, [tag4, tag5, tag6])
    }
    
    func testItemsCollectionMergeWithZeroOrOneItem() {
        let items: [ImportItem] = []
        XCTAssertFalse(items.canMerge)
        
        let oneItem: [ImportItem] = [item1]
        XCTAssertFalse(oneItem.canMerge)
    }
    
    func testItemsCollectionWithSameTagsMerge() {
        XCTAssertEqual([item1, item2, item3].canMerge, true)
        XCTAssertEqual([item1, item2].canMerge, true)
        XCTAssertEqual([item2, item3].canMerge, true)

        item1.tags = [tag1, tagUno]
        item2.tags = [tagUno, tag1]
        item3.tags = [tagUno, tag1]

        XCTAssertEqual([item1, item2, item3].canMerge, true)
        XCTAssertEqual([item1, item2].canMerge, true)
        XCTAssertEqual([item2, item3].canMerge, true)
    }

    func testItemsCollectionWithDifferentTagsCannotMerge() {
        let tags1 = [tag1!, tagUno!]
        let tags2 = [tag2!, tagDio!]
        let tags3 = [tag3!, tagTrio!]

        item1.tags = tags1
        item2.tags = tags2
        item3.tags = tags3

        XCTAssertEqual([item1, item2, item3].canMerge, false)
        XCTAssertEqual([item1, item2].canMerge, false)
        XCTAssertEqual([item2, item3].canMerge, false)
    }
    
    func testItemsCollectionContainingMultipleImagesCannotMerge() {
        XCTAssertFalse([item1, item4].canMerge)
    }
    
    func testItemsCollectionWithNoTagsCanMerge() {
        XCTAssertTrue([item1, item2, item3].canMerge)
    }
    
    func testEmptyOrSingleItemsCollectionHasSameTags() {
        let emptyItems: [ImportItem] = []
        XCTAssertTrue(emptyItems.hasSameTags)
        
        let singleItem: [ImportItem] = [item4]
        XCTAssertTrue(singleItem.hasSameTags)
    }
    
    func testItemsCollectionHasDifferentTags() {
        item1.tags = [tag1, tagUno]
        item2.tags = [tagUno, tag1]
        item3.tags = [tagUno, tag1]
        item4.tags = [tag2, tagDio]
        
        XCTAssertFalse([item1, item2, item3, item4].hasSameTags)
    }
    
    func testItemsCollectionHasSameTags() {
        item1.tags = [tag1, tagUno]
        item2.tags = [tagUno, tag1]
        item3.tags = [tagUno, tag1]
        item4.tags = [tag1, tagUno]
        
        XCTAssertTrue([item1, item2, item3, item4].hasSameTags)
    }
    
    func testItemsCollectionReturnEmptyTagsWhenCollectionEmpty() {
        let items: [ImportItem] = []
        XCTAssertTrue(items.tags.isEmpty)
    }
    
    func testItemsCollectionReturnTagsWhenCollectionHasOneItem() {
        item2.tags = [tagUno, tag1]
        XCTAssertEqual([item2].tags, [tagUno, tag1])
    }
    
    func testItemsCollectionReturnEmptyTagsWhenNotMatched() {
        item1.tags = [tag1, tagUno]
        item2.tags = [tagUno, tag1]
        item3.tags = [tagUno, tag1]
        item4.tags = [tag2, tagDio]
        
        XCTAssertTrue([item1, item2, item3, item4].tags.isEmpty)
    }
    
    func testItemsCollectionReturnFirstItemTagsWhenMatched() {
        item1.tags = [tag1, tagUno]
        item2.tags = [tagUno, tag1]
        item3.tags = [tagUno, tag1]
        item4.tags = [tagUno, tag1]
        
        XCTAssertEqual([item1, item2, item3, item4].tags, [tag1, tagUno])
    }
    
    func testItemsCollectionWithNoItemsCanTag() {
        let emptyItems: [ImportItem] = []
        XCTAssertFalse(emptyItems.canTag)
    }
    
    func testItemsCollectionWithSingleItemCanTag() {
        let singleItem: [ImportItem] = [item1]
        XCTAssertTrue(singleItem.canTag)
    }
    
    func testItemsCollectionWithSameTagsCanTag() {
        item1.tags = [tag1, tagUno]
        item2.tags = [tagUno, tag1]
        item3.tags = [tagUno, tag1]
        item4.tags = [tag1, tagUno]
        
        XCTAssertTrue([item1, item2, item3, item4].canTag)
    }
    
    func testItemsCollectionWithDifferentTagsCannotTag() {
        item1.tags = [tag1, tagUno]
        item2.tags = [tagUno, tag1]
        item3.tags = [tagUno, tag1]
        item4.tags = [tag2, tagDio]
        
        XCTAssertFalse([item1, item2, item3, item4].canTag)
    }
}
