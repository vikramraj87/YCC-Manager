//
//  SingleThumbnailItem.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 04/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

class SingleThumbnailItem: NSCollectionViewItem {
    var thumbnail: NSImage? {
        didSet {
            view.layer?.contents = thumbnail
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.white.cgColor
        view.layer?.borderWidth = 1.0
        view.layer?.contentsGravity = .resizeAspectFill
    }
    
}
