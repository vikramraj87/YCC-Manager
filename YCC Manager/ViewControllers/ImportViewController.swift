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
    var items: [ImportItem] = [] {
        didSet {
            validateImport()
        }
    }
    
    @IBOutlet weak var thumbnailView: NSCollectionView!
    @IBOutlet weak var mergeButton: NSButton!
    @IBOutlet weak var unmergeButton: NSButton!
    @IBOutlet weak var removeItemsButton: NSButton!
    
    @IBOutlet weak var keywordsTokenField: NSTokenField!
    @IBOutlet weak var importButton: NSButton!
    @IBOutlet weak var copyCheckBox: NSButton!
    
    private var validKeywords: [String] = []
    
    var selectedItems: [ImportItem] { items(at: thumbnailView.selectionIndexPaths) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        
        validateImport()
        
        validateMergeUnmerge()
        validateRemoveItems()
        validateTagging()
        
        configureCollectionView(thumbnailView)
        configureTokenField(keywordsTokenField)
    }
    
    private func configureTokenField(_ tokenField: NSTokenField) {
        tokenField.delegate = self
        
        // Load valid keywords from database
        validKeywords = [
            "Ring", "AD Stone", "Matt finish",
            "Haaram", "Necklace", "Antique finish",
            "Hip belt", "Hip chain", "Bridal set",
            "Dual set", "Bracelet", "Toe ring",
            "Oxidised jewellery"
        ]

        // TODO: Observe changes in keywords to update the list
    }
    
    private func configureCollectionView(_ collectionView: NSCollectionView) {
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
        
        items = items.removedElementsAtIndexes(arrayIndexesToMerge)
        
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
    
    private func item(at indexPath: IndexPath) -> ImportItem {
        return items[indexPath.item]
    }
    
    private func items(at indexPaths: Set<IndexPath>) -> [ImportItem] {
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
    
    @IBAction func removeImages(_ sender: Any) {
        let selectedIndexpaths = thumbnailView.selectionIndexPaths
        let arrayIndexes = selectedIndexpaths.map { return $0.item }
        items = items.removedElementsAtIndexes(arrayIndexes)
        thumbnailView.deleteItems(at: selectedIndexpaths)
    }
    
    @IBAction func performImport(_ sender: Any) {
        let isCopy = copyCheckBox.state == .on ? true : false
        print("Copy: \(isCopy)")
        
        // Show select dealer modal
        
        // When dealer is selected
        // create coredata models
        // copy/move images to app folder
        // rename file to match the uuid of item
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
        
        thumbnailItem.hasTags = !item.tags.isEmpty
        
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
        validateRemoveItems()
        validateTagging()
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        validateMergeUnmerge()
        validateRemoveItems()
        validateTagging()
    }
    
    private func validateTagging() {
        let selectedItems = self.selectedItems
        keywordsTokenField.isEnabled = selectedItems.canTag
        keywordsTokenField.objectValue = selectedItems.tags
    }
    
    private func validateMergeUnmerge() {
        unmergeButton.isEnabled = canUnmerge()
        mergeButton.isEnabled = selectedItems.canMerge
    }
    
    private func validateRemoveItems() {
        removeItemsButton.isEnabled = !thumbnailView.selectionIndexPaths.isEmpty
    }
    
    private func validateImport() {
        copyCheckBox.isEnabled = !items.isEmpty
        importButton.isEnabled = !items.isEmpty
    }
    
    private func canUnmerge() -> Bool {
        if thumbnailView.selectionIndexPaths.count != 1 {
            return false
        }
        
        let selectedItem = item(at: thumbnailView.selectionIndexPaths.first!)
        
        return selectedItem.hasMultipleImages
    }
    
    private func canTag() -> Bool {
        let selectedIndexPaths = thumbnailView.selectionIndexPaths
        
        guard !selectedIndexPaths.isEmpty else { return false }
        
        if selectedIndexPaths.count == 1 { return true }
        
        return items(at: selectedIndexPaths).hasSameTags
    }
    
    private func tagSelectedItems(with tags: [String]) {
        let selectedIndexPaths = thumbnailView.selectionIndexPaths
        
        guard !selectedIndexPaths.isEmpty else { return }
        
        for indexPath in selectedIndexPaths {
            items[indexPath.item].tags = tags
        }
    }
}

extension ImportViewController: NSTokenFieldDelegate {
    func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String, indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        return validKeywords.filter {
            $0.lowercased().hasPrefix(substring.lowercased())
        }
    }
    
    func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
        let keywordsToAdd = tokens.compactMap { $0 as? String }
        return keywordsToAdd.filter { validKeywords.contains($0) }
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let tokenField = obj.object as? NSTokenField else { return }
        let filtered = filteredKeywords(from: tokenField)
        tokenField.objectValue = filtered
        
        thumbnailView.reloadItems(at: thumbnailView.selectionIndexPaths)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        guard let tokenField = obj.object as? NSTokenField else { return }
        let filtered = filteredKeywords(from: tokenField)
        tagSelectedItems(with: filtered)
    }
    
    func filteredKeywords(from tokenField: NSTokenField) -> [String] {
        guard let words = tokenField.objectValue as? [String] else { return [] }
        return words.filter { validKeywords.contains($0) }
    }
}
