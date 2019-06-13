//
//  ImportItemProtocol.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 13/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

protocol ImportItemProtocol {
    var imageURLs: [URL] { get set }
    
    mutating func merge(with items: [ImportItemProtocol])
    mutating func unmerge() -> [ImportItemProtocol]
    
    var hasMultipleImages: Bool { get }
    
    func contains(_ url: URL) -> Bool
}

extension ImportItemProtocol {
    var hasMultipleImages: Bool {
        return imageURLs.count > 1
    }
    
    mutating func merge(with items: [ImportItemProtocol]) {
        for item in items {
            self.imageURLs.append(contentsOf: item.imageURLs)
        }
    }
    
    func contains(_ url: URL) -> Bool {
        return imageURLs.contains(url)
    }
}

struct ImportItem {
    var imageURLs: [URL]
    
    init(imageURLs: [URL]) {
        self.imageURLs = imageURLs
    }
    
    init(imageURL: URL) {
        self.init(imageURLs: [imageURL])
    }
}

extension ImportItem: ImportItemProtocol {
    mutating func unmerge() -> [ImportItemProtocol] {
        guard imageURLs.count > 1 else { return [] }

        let firstImageURL = imageURLs.first!

        let newItems = imageURLs.dropFirst().map { ImportItem(imageURL: $0) }
        imageURLs = [firstImageURL]
        return newItems
    }
}
