//
//  ImportItemProtocol.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 13/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

protocol ImportItemProtocol {
    var images: [NSImage] { get set }
    
    mutating func merge(_ items: [ImportItemProtocol])
    mutating func unmerge() -> [ImportItemProtocol]
    
    var hasMultipleImages: Bool { get }
}

extension ImportItemProtocol {
    var hasMultipleImages: Bool {
        return images.count > 1
    }
    
    mutating func merge(_ items: [ImportItemProtocol]) {
        for item in items {
            self.images.append(contentsOf: item.images)
        }
    }
    
    mutating func unmerge() -> [ImportItemProtocol] {
        guard images.count > 1 else { return [] }
        
        let firstImage = images.first!
        
        let newItems = images.dropFirst().map { return ImportItem(image: $0) }
        images = [firstImage]
        return newItems
    }
}

struct ImportItem {
    var images: [NSImage] = []
    
    init(images: [NSImage]) {
        self.images = images
    }
    
    init(image: NSImage) {
        self.images = [image]
    }
}

extension ImportItem: ImportItemProtocol {}
