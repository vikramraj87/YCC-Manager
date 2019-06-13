//
//  ImportViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 01/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa



extension NSNib.Name {
    static let multipleThumbnailItem = NSNib.Name("MultipleThumbnailItem")
}

extension NSUserInterfaceItemIdentifier {
    static let multipleThumbnailItem = NSUserInterfaceItemIdentifier("MultipleThumbnailItem")
}

class ImportViewController: NSViewController {
    var items: [ImportItemProtocol] = []
    
    @IBOutlet weak var thumbnailView: NSCollectionView!
    @IBOutlet weak var mergeButton: NSButton!
    @IBOutlet weak var unmergeButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        
        mergeButton.isEnabled = false
        unmergeButton.isEnabled = false
        
        configure(thumbnailView)
    }
    
    private func configure(_ collectionView: NSCollectionView) {
        let multipleThumbnailItem = NSNib(nibNamed: .multipleThumbnailItem, bundle: nil)
        
        collectionView.register(multipleThumbnailItem, forItemWithIdentifier: .multipleThumbnailItem)
        
        collectionView.wantsLayer = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isSelectable = true
        collectionView.allowsEmptySelection = true
        collectionView.allowsMultipleSelection = true
        
        let layout = NSCollectionViewGridLayout()
        layout.margins = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.minimumItemSize = NSSize(width: 240, height: 320)
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        
        collectionView.collectionViewLayout = layout
    }
    
    private func mergeItems(at indexes: Set<IndexPath>) {
        let sortedIndexes = indexes.sorted { return $0.item <  $1.item }
        
        guard let firstIndex = sortedIndexes.first else {
            print("Cannot fetch the first item indexpath for merging other items with")
            return
        }
        
        let indexesToMerge = sortedIndexes.dropFirst()
        let arrayIndexesToMerge = indexesToMerge.map { return $0.item }
        let itemsToMerge = arrayIndexesToMerge.map { return items[$0] }
        
        items[firstIndex.item].merge(with: itemsToMerge)
        
        var newItems: [ImportItemProtocol] = []
        for (index, item) in items.enumerated() {
            if arrayIndexesToMerge.contains(index) != true {
                newItems.append(item)
            }
        }
        items = newItems
        
        thumbnailView.deleteItems(at: Set(indexesToMerge))
        thumbnailView.reloadItems(at: Set([firstIndex]))
        thumbnailView.selectItems(at: Set([firstIndex]), scrollPosition: .centeredVertically)
    }
    
    private func unmergeItem(at index: IndexPath) {
        let itemsToAdd = items[index.item].unmerge()
        
        items.insert(contentsOf: itemsToAdd, at: index.item + 1)
        
        var insertedIndexPaths: [IndexPath] = []
        for currIndex in 1...itemsToAdd.count {
            insertedIndexPaths.append(IndexPath(item: currIndex + index.item, section: 0))
        }
        
        thumbnailView.insertItems(at: Set(insertedIndexPaths))
        thumbnailView.reloadItems(at: Set([index]))
        thumbnailView.selectItems(at: Set([index]).union(insertedIndexPaths), scrollPosition: .centeredVertically)
    }
    
    private func item(at indexPath: IndexPath) -> ImportItemProtocol {
        return items[indexPath.item]
    }
    
    private func items(at indexPaths: Set<IndexPath>) -> [ImportItemProtocol] {
        return indexPaths.map { return items[$0.item] }
    }
    
    @IBAction func mergeImages(_ sender: Any) {
        mergeItems(at: thumbnailView.selectionIndexPaths)
        validateMergeUnmerge()
    }
    
    @IBAction func unmergeImages(_ sender: Any) {
        unmergeItem(at: thumbnailView.selectionIndexPaths.first!)
        validateMergeUnmerge()
    }
    
    @IBAction func addImages(_ sender: Any) {
        importImages()
    }
    
    private func importImages() {
        guard let window = view.window else {
            print("No window to present open panel")
            return
        }
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = true
        
        openPanel.beginSheetModal(for: window) { [weak self] response in
            guard response == .OK else { return }
            
            self?.processSelectedURLs(openPanel.urls)
        }
    }
    
    private func processSelectedURLs(_ urls: [URL]) {
        // TODO: Add extensions to UserDefaults
        let allowedExtensions = ["jpg", "jpeg"]
        
        let newItems =  urls.filter { url in // Filter valid extensions
            let fileExtension = url.pathExtension.lowercased()
            return allowedExtensions.contains(fileExtension)
        }.filter { url in                    // Filter duplicates
            for item in items {
                if item.contains(url) { return false }
            }
            return true
        }.map { ImportItem(imageURL: $0) }  // Convert URLs to Items
        
        items.append(contentsOf: newItems)
        thumbnailView.reloadData()
    }
}

extension ImportViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = self.items[indexPath.item]
        

        let viewItem = collectionView.makeItem(withIdentifier: .multipleThumbnailItem, for: indexPath)
        guard let thumbnailItem = viewItem as? MultipleThumbnailItem else {
            print("Cannot get multiple thumbnail item")
            return viewItem
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let downsizedImages = item.imageURLs.compactMap {
                ImageDownSampler.downsample(imageAt: $0, to: 500)
            }
            DispatchQueue.main.async {
                thumbnailItem.thumbnails = downsizedImages
            }
        }
        
        return thumbnailItem
    }
}

extension ImportViewController: NSCollectionViewDelegate {
    // For validating merge and unmerge buttons
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        validateMergeUnmerge()
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        validateMergeUnmerge()
    }
    
    private func validateMergeUnmerge() {
        unmergeButton.isEnabled = canUnmerge()
        mergeButton.isEnabled = canMerge()
    }
    
    private func canUnmerge() -> Bool {
        if thumbnailView.selectionIndexPaths.count != 1 {
            return false
        }
        
        let selectedItem = item(at: thumbnailView.selectionIndexPaths.first!)
        
        return selectedItem.hasMultipleImages
    }
    
    private func canMerge() -> Bool {
        if thumbnailView.selectionIndexPaths.count < 2 {
            return false
        }
        
        for item in items(at: thumbnailView.selectionIndexPaths) {
            if item.hasMultipleImages {
                return false
            }
        }
        
        return true
    }
}
