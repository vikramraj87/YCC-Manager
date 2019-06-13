//
//  MultipleThumbnailPreviewViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 04/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

extension NSNib.Name {
    static let singleThumbnailItem = NSNib.Name("SingleThumbnailItem")
}

extension NSUserInterfaceItemIdentifier {
    static let singleThumbnailItem = NSUserInterfaceItemIdentifier("SingleThumbnailItem")
}

extension NSStoryboard.SceneIdentifier {
    static let multipleThumbnailPreviewController = NSStoryboard.SceneIdentifier("MultipleThumbnailPreviewController")
}

class MultipleThumbnailPreviewViewController: NSViewController {
    @IBOutlet weak var thumbnailView: NSCollectionView!
    
    var images: [NSImage] = [] {
        didSet {
            thumbnailView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbnailView.wantsLayer = true
        thumbnailView.dataSource = self
        
        let layout = NSCollectionViewGridLayout()
        layout.margins = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.minimumItemSize = NSSize(width: 180, height: 240)
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        
        thumbnailView.collectionViewLayout = layout
        
    }
}

extension MultipleThumbnailPreviewViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .singleThumbnailItem, for: indexPath)
        
        guard let singleThumbnailItem = item as? SingleThumbnailItem else {
            print("Cannot initialize single thumbnail item")
            return item
        }
        
        singleThumbnailItem.thumbnail = images[indexPath.item]
        return singleThumbnailItem
        
    }
}
