//
//  ImportItemTests.swift
//  YCC ManagerTests
//
//  Created by Vikram Raj Gopinathan on 14/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest
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
    
    override func setUp() {
        item1 = ImportItem(imageURL: url1)
        item2 = ImportItem(imageURL: url2)
        item3 = ImportItem(imageURL: url3)
        item4 = ImportItem(imageURLs: [url4, url5, url6])
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
        item1.tags = ["One", "Two", "Three"]
        item2.tags = ["Three", "Four", "Five"]
        item3.tags = ["Four", "Five", "Six"]
        
        item1.merge(with: [item2, item3])
        XCTAssertEqual(item1.imageURLs, [url1, url2, url3])
        XCTAssertEqual(item1.tags, ["One", "Two", "Three"])
    }
    
    func testMergeWithMultipleURLItems() {
        item1.tags = ["One", "Two", "Three"]
        item4.tags = ["Four", "Five", "Six"]
        
        item1.merge(with: [item4])
        XCTAssertEqual(item1.imageURLs, [url1, url4, url5, url6])
        XCTAssertEqual(item1.tags, ["One", "Two", "Three"])
    }
    
    func testUnmerge() {
        item4.tags = ["Four", "Five", "Six"]
        
        let unmergedItems = item4.unmerge()
        XCTAssertEqual(item4.imageURLs, [url4])
        XCTAssertEqual(unmergedItems[0].imageURLs, [url5])
        XCTAssertEqual(unmergedItems[1].imageURLs, [url6])
        
        XCTAssertEqual(item4.tags, ["Four", "Five", "Six"])
        XCTAssertEqual(unmergedItems[0].tags, ["Four", "Five", "Six"])
        XCTAssertEqual(unmergedItems[1].tags, ["Four", "Five", "Six"])
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

        item1.tags = ["One", "Uno"]
        item2.tags = ["Uno", "One"]
        item3.tags = ["Uno", "One"]

        XCTAssertEqual([item1, item2, item3].canMerge, true)
        XCTAssertEqual([item1, item2].canMerge, true)
        XCTAssertEqual([item2, item3].canMerge, true)
    }

    func testItemsCollectionWithDifferentTagsCannotMerge() {
        let tags1 = ["One", "Uno"]
        let tags2 = ["Two", "Duo"]
        let tags3 = ["Three", "Trio"]

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
        item1.tags = ["One", "Uno"]
        item2.tags = ["Uno", "One"]
        item3.tags = ["Uno", "One"]
        item4.tags = ["Two", "Duo"]
        
        XCTAssertFalse([item1, item2, item3, item4].hasSameTags)
    }
    
    func testItemsCollectionHasSameTags() {
        item1.tags = ["One", "Uno"]
        item2.tags = ["Uno", "One"]
        item3.tags = ["Uno", "One"]
        item4.tags = ["One", "Uno"]
        
        XCTAssertTrue([item1, item2, item3, item4].hasSameTags)
    }
    
    func testItemsCollectionReturnEmptyTagsWhenCollectionEmpty() {
        let items: [ImportItem] = []
        XCTAssertTrue(items.tags.isEmpty)
    }
    
    func testItemsCollectionReturnTagsWhenCollectionHasOneItem() {
        item2.tags = ["Uno", "One"]
        XCTAssertEqual([item2].tags, ["Uno", "One"])
    }
    
    func testItemsCollectionReturnEmptyTagsWhenNotMatched() {
        item1.tags = ["One", "Uno"]
        item2.tags = ["Uno", "One"]
        item3.tags = ["Uno", "One"]
        item4.tags = ["Two", "Duo"]
        
        XCTAssertTrue([item1, item2, item3, item4].tags.isEmpty)
    }
    
    func testItemsCollectionReturnFirstItemTagsWhenMatched() {
        item1.tags = ["One", "Uno"]
        item2.tags = ["Uno", "One"]
        item3.tags = ["Uno", "One"]
        item4.tags = ["Uno", "One"]
        
        XCTAssertEqual([item1, item2, item3, item4].tags, ["One", "Uno"])
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
        item1.tags = ["One", "Uno"]
        item2.tags = ["Uno", "One"]
        item3.tags = ["Uno", "One"]
        item4.tags = ["One", "Uno"]
        
        XCTAssertTrue([item1, item2, item3, item4].canTag)
    }
    
    func testItemsCollectionWithDifferentTagsCannotTag() {
        item1.tags = ["One", "Uno"]
        item2.tags = ["Uno", "One"]
        item3.tags = ["Uno", "One"]
        item4.tags = ["Two", "Duo"]
        
        XCTAssertFalse([item1, item2, item3, item4].canTag)
    }
}
