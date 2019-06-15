//
//  ImportItemProtocol.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 13/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

struct ImportItem {
    var imageURLs: [URL]
    var tags: [String]
    
    init(imageURLs: [URL], tags: [String]) {
        self.imageURLs = imageURLs
        self.tags = tags
    }
    
    init(imageURLs: [URL]) {
        self.init(imageURLs: imageURLs, tags: [])
    }
    
    init(imageURL: URL) {
        self.init(imageURLs: [imageURL])
    }
    
    mutating func merge(with items: [ImportItem]) {
        for item in items {
            self.imageURLs.append(contentsOf: item.imageURLs)
        }
    }
    
    mutating func unmerge() -> [ImportItem] {
        guard imageURLs.count > 1 else { return [] }
        
        let firstImageURL = imageURLs.first!
        
        let newItems = imageURLs.dropFirst().map { ImportItem(imageURLs: [$0], tags: tags) }
        
        imageURLs = [firstImageURL]
        return newItems
    }
    
    var hasMultipleImages: Bool {
        return imageURLs.count > 1
    }
    
    func contains(_ url: URL) -> Bool {
        return imageURLs.contains(url)
    }
}


extension Collection where Element == ImportItem {
    var canMerge: Bool {
        guard count > 1 else { return false }
        
        let tags = first!.tags.sorted()
        
        for item in self {
            if item.hasMultipleImages { return false }
            
            if item.tags.sorted() != tags { return false }
        }
        
        return true
    }
    
    var hasSameTags: Bool {
        guard count > 1 else { return true }
        
        let tags = first!.tags.sorted()
        
        for item in self {
            if item.tags.sorted() != tags { return false }
        }
        
        return true
    }
    
    var tags: [String] {
        guard hasSameTags else { return [] }
        
        guard let firstItem = first else { return [] }
        
        return firstItem.tags
    }
}
