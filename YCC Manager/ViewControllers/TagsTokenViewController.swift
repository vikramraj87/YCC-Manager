//
//  TagsTokenViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 27/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

protocol TagsTokenViewControllerDelegate: class {
    func tagsDidChanged(_ tags: [TagMO])
    func tagsEditingEnded()
}

class TagsTokenViewController: NSViewController {
    
    @IBOutlet private var tokenField: NSTokenField!
    
    private lazy var tagsFRC: NSFetchedResultsController<TagMO> = {
        let fetchRequest: NSFetchRequest<TagMO> = TagMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \TagMO.tag, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        let context = DataController.shared.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    // Cache for all tags
    private var fetchedTagNames: [String] = []
    
    // Current valid tags
    private var selectedTags: [TagMO] = []
    
    public weak var delegate: TagsTokenViewControllerDelegate?
    
    public var isEnabled: Bool {
        get {
            return tokenField.isEnabled
        }
        set {
            tokenField.isEnabled = newValue
        }
    }
    
    public func configure(for tags: [TagMO]) {
        selectedTags = tags
        tokenField.objectValue = selectedTags.map { $0.tag }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenField.delegate = self
        tokenField.isEnabled = false
        do {
            try tagsFRC.performFetch()
            if let tags = tagsFRC.fetchedObjects {
                fetchedTagNames = tags.map { $0.tag }
            }
        } catch {
            // TODO: - Notify user
            print("Error fetching tags: \(error)")
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        selectedTags = []
    }
}

extension TagsTokenViewController: NSTokenFieldDelegate {
    func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String, indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        let suggestions = fetchedTagNames.filter {
            $0.lowercased().hasPrefix(substring.lowercased())
        }
        
        // Filter duplicates
        return filterDuplicateEntries(suggestions, in: tokenField)
    }
    
    func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
        // Get words from token field
        let tokensToAdd = tokens.compactMap { $0 as? String }
        
        // Filter only available tag names
        let validTokens = tokensToAdd.filter { fetchedTagNames.contains($0) }
        
        // Filter duplicates
        return filterDuplicateEntries(validTokens, in: tokenField)
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let tokenField = obj.object as? NSTokenField,
            let allTokens = tokenField.objectValue as? [String] else {
                return
        }
        
        let validTokes = allTokens.filter { fetchedTagNames.contains($0) }
        
        tokenField.objectValue = validTokes
        
        // Call delegate
        // To update thumbnails with icon
        delegate?.tagsEditingEnded()
    }
    
    func controlTextDidChange(_ obj: Notification) {
        // Get tags from all tokens and update selected tags
        guard let tokenField = obj.object as? NSTokenField,
            let allTokens = tokenField.objectValue as? [String] else {
            return
        }
        let tags = tagsFromTokens(allTokens)
        if Set(selectedTags) != Set(tags) {
            selectedTags = tags
            
            // Call delegate to
            // update selected items with tags
            delegate?.tagsDidChanged(tags)
        }
    }
    
    private func tagsFromTokens(_ tokens: [String]) -> [TagMO] {
        let fetchRequest: NSFetchRequest<TagMO> = TagMO.fetchRequest()
        let predicate = NSPredicate(format: "tag IN[c] %@", tokens)
        fetchRequest.predicate = predicate
        
        let context = DataController.shared.viewContext
        var tags: [TagMO] = []
        do {
            tags = try context.fetch(fetchRequest)
        } catch {
            // TODO: Notify user
            print("Error fetching filtered tags: \(error)")
        }
        return tags
    }
    
    private func filterDuplicateEntries(_ entries: [String], in tokenField: NSTokenField) -> [String] {
        guard let allTokens = tokenField.objectValue as? [String] else { return entries }
        
        // Ignore the last entry which is incomplete
        let existingTokens = allTokens.dropLast()
        
        return entries.filter {
            !existingTokens.contains($0)
        }
    }
}

extension TagsTokenViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let tags = tagsFRC.fetchedObjects else { return }
        print("Fetched tags updated with \(tags.count) items")
        fetchedTagNames = tags.map { $0.tag }
    }
}
