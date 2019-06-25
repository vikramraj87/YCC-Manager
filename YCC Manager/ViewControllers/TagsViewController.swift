//
//  TagsViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 23/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

extension NSUserInterfaceItemIdentifier {
    static let tagNameColumn = NSUserInterfaceItemIdentifier(rawValue: "TagColumn")
    static let tagNameCell = NSUserInterfaceItemIdentifier(rawValue: "TagCell")
}

class TagsViewController: NSViewController {
    
    @IBOutlet var tagsTableView: NSTableView!
    @IBOutlet var editButton: NSButton!
    @IBOutlet var removeButton: NSButton!
    
    var dataSource: TableViewFetchedResultsControllerDataSource<TagMO>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        configDataSource()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        configButtons()
    }
    
    private func configTableView() {
        tagsTableView.delegate = self
        
        tagsTableView.allowsEmptySelection = true
        tagsTableView.allowsColumnSelection = false
        tagsTableView.allowsMultipleSelection = false
    }
    
    private func configDataSource() {
        // Configure fetch request
        let fetchRequest: NSFetchRequest<TagMO> = TagMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \TagMO.tag, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Get the context
        let context = DataController.shared.viewContext
        
        // Initialize the Data source
        do {
            dataSource = try TableViewFetchedResultsControllerDataSource(tableView: tagsTableView,
                                                                         fetchRequest: fetchRequest,
                                                                         context: context)
        } catch {
            print("Error initializing data source for tags: \(error)")
        }
    }
    
    private func configButtons() {
        editButton.isEnabled = false
        removeButton.isEnabled = false
    }
    
    @IBAction func addTag(_ sender: Any) {
        // Instantiate controller
        let vc = storyboard?.instantiateController(withIdentifier: .editTagViewController)
        guard let editTagVC = vc as? EditTagViewController else { return }
        editTagVC.delegate = self
        
        // Present controller
        self.presentAsSheet(editTagVC)
    }
    
    @IBAction func editTag(_ sender: Any) {
        // Fetch tag to edit
        guard let tag = dataSource?.selectedObject else { return }
        
        // Instantiate controller
        let vc = storyboard?.instantiateController(withIdentifier: .editTagViewController)
        guard let editTagVC = vc as? EditTagViewController else { return }
        editTagVC.delegate = self
        editTagVC.tagToEdit = tag
        
        // Present controller
        self.presentAsSheet(editTagVC)
    }
}

extension TagsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        guard let column = tableColumn else { return }
        guard let dataSource = self.dataSource else { return nil }
        
        let cellIdentifier: NSUserInterfaceItemIdentifier
        let cellContent: String
        
        cellIdentifier = .tagNameCell
        cellContent = dataSource.objectForRow(row).tag
        
        guard let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView else {
            return nil
        }
        cell.textField?.stringValue = cellContent
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let dataSource = dataSource else { return }
        
        // Validate edit button
        editButton.isEnabled = dataSource.selectedObject != nil
        
        // Validate remove button
        removeButton.isEnabled = canBeDeleted()
    }
    
    private func canBeDeleted() -> Bool {
        return false
    }
}

extension TagsViewController: EditTagViewControllerDelegate {
    func addTagWithTagName(_ name: String) {
        if isDuplicate(name: name, tag: nil) {
            showDuplicateAlert()
            return
        }
        
        let tag = TagMO(context: DataController.shared.viewContext)
        tag.tag = name
        
        DataController.shared.saveDefaultContext()
    }
    
    func updateTag(_ tag: TagMO, name: String) {
        if isDuplicate(name: name, tag: tag) {
            showDuplicateAlert()
            return
        }
        
        tag.tag = name
        
        DataController.shared.saveDefaultContext()
    }
    
    private func isDuplicate(name: String, tag: TagMO?) -> Bool {
        // Configure fetch request to find duplicate
        let fetchRequest: NSFetchRequest<TagMO> = TagMO.fetchRequest()
        let tagPredicate = NSPredicate(format: "%K ==[c] %@", "tag", name)
        fetchRequest.predicate = tagPredicate
        
        let context = DataController.shared.viewContext
        var fetchedTags: [TagMO] = []
        do {
            fetchedTags = try context.fetch(fetchRequest)
        } catch {
            print("Error checking duplicate tag: \(error)")
        }
        
        // Zero tags returned. No duplicate
        if fetchedTags.isEmpty { return false }
        
        // 1 or more tags with same name
        // if this is not edit mode, then duplicate entry
        guard let tagToEdit = tag else { return true }
        
        // Check the returned tag is the same as
        // tag to edit. If so not duplicate
        // else duplicate
        let fetchedTag = fetchedTags.first!
        return fetchedTag.objectID != tagToEdit.objectID
    }
    
    private func showDuplicateAlert() {
        guard let window = view.window else { return }
        let alert = NSAlert()
        alert.messageText = "Duplicate Tag"
        alert.informativeText = "Cannot add/update tag. Tag already exists"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
}
