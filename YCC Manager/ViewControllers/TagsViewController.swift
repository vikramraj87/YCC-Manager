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
    
    lazy var duplicateChecker: DuplicateChecker<TagMO> = {
        let dc = DuplicateChecker<TagMO>(context: DataController.shared.viewContext,
                                         predicateFormat: "tag ==[c] %@")
        return dc
    }()
    
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
        var isDuplicate = true
        do {
            isDuplicate = try duplicateChecker.isDuplicateValue(name, objectUpdated: tag)
        } catch {
            print("Error checking for duplicate tag: \(error)")
        }
        return isDuplicate
    }
    
    private func showDuplicateAlert() {
        guard let window = view.window else { return }
        
        NSAlert.showInfo(message: "Duplicate Tag",
                         detail: "Cannot add/update tag. Tag already exists",
                         window: window)
    }
}
