//
//  DealersViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 16/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import CoreData

extension NSUserInterfaceItemIdentifier {
    static let dealerNameColumn = NSUserInterfaceItemIdentifier(rawValue: "DealerNameColumn")
    static let dealerMobileColumn = NSUserInterfaceItemIdentifier(rawValue: "DealerMobileColumn")
    
    static let dealerNameCell = NSUserInterfaceItemIdentifier(rawValue: "NameCellID")
    static let dealerMobileCell = NSUserInterfaceItemIdentifier(rawValue: "MobileCellID")
}

class DealersViewController: NSViewController {
    
    @IBOutlet var dealersTableView: NSTableView!
    @IBOutlet var editButton: NSButton!
    @IBOutlet var removeButton: NSButton!
    
    var dataSource: TableViewFetchedResultsControllerDataSource<DealerMO>?
    
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
        dealersTableView.delegate = self
        
        dealersTableView.allowsEmptySelection = true
        dealersTableView.allowsColumnSelection = false
        dealersTableView.allowsMultipleSelection = false
    }
    
    private func configDataSource() {
        // Configure fetch request
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \DealerMO.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Get context
        let context = DataController.shared.viewContext
        
        // Initialize the Data source
        do {
            dataSource = try TableViewFetchedResultsControllerDataSource(tableView: dealersTableView,
                                                                         fetchRequest: fetchRequest,
                                                                         context: context)
        } catch {
            print("Error loading data source for dealers: \(error)")
        }
    }
    
    private func configButtons() {
        editButton.isEnabled = false
        removeButton.isEnabled = false
    }
    
    @IBAction func createDealer(_ sender: Any) {
        guard let currSB = storyboard else { return }
        
        guard let editDealerVC = currSB.instantiateController(withIdentifier: .editDealerViewController) as? EditDealerViewController else { return }
        
        editDealerVC.delegate = self
        
        self.presentAsSheet(editDealerVC)
    }
    
    @IBAction func editDealer(_ sender: Any) {
        guard let dealerToEdit = dataSource?.selectedObject else { return }
        
        guard let currSB = storyboard,
            let editDealerVC = currSB.instantiateController(withIdentifier: .editDealerViewController) as? EditDealerViewController else { return }
        
        editDealerVC.delegate = self
        editDealerVC.dealerToEdit = dealerToEdit
        
        self.presentAsSheet(editDealerVC)
    }
    
    @IBAction func removeDealer(_ sender: Any) {
        guard let _ = dataSource?.selectedObject else { return }
        
    }
}

extension DealersViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn,
            let dataSource = self.dataSource else {
                return nil
        }
        
        let dealer = dataSource.objectForRow(row)
        
        let cellIdentifier: NSUserInterfaceItemIdentifier
        let cellContent: String
        
        if column.identifier == .dealerNameColumn {
            cellIdentifier = .dealerNameCell
            cellContent = dealer.name
        } else { // if column.identifier == .dealerMobileColumn
            cellIdentifier = .dealerMobileCell
            cellContent = dealer.mobileNumber
        }
        
        guard let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView else {
            return nil
        }
        cell.textField?.stringValue = cellContent
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else {
            print("Tableview not fetched")
            return
        }
        
        // Validate edit button
        editButton.isEnabled = (tableView.selectedRow != -1)
        
        // Validate remove button
        removeButton.isEnabled = canBeDeleted()
    }
    
    private func canBeDeleted() -> Bool {
        return false
    }
}

extension DealersViewController: EditDealerViewControllerDelegate {
    func addDealerWithName(_ name: String, mobileNumber: String) {
        if isDuplicate(name: name, mobile: mobileNumber, dealer: nil) {
            showDuplicateAlert()
            return
        }
        
        let dealer = DealerMO(context: DataController.shared.viewContext)
        dealer.name = name
        dealer.mobileNumber = mobileNumber
        
        DataController.shared.saveDefaultContext()
    }
    
    func updatedDealer(_ dealer: DealerMO, name: String, mobileNumber: String) {
        if isDuplicate(name: name, mobile: mobileNumber, dealer: dealer) {
            showDuplicateAlert()
            return
        }
        dealer.name = name
        dealer.mobileNumber = mobileNumber
        DataController.shared.saveDefaultContext()
    }
    
    private func isDuplicate(name: String, mobile: String, dealer: DealerMO?) -> Bool {
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        let mobileNumberPredicate = NSPredicate(format: "%K ==[c] %@", "mobileNumber", mobile)
        fetchRequest.predicate = mobileNumberPredicate
        
        let context = DataController.shared.viewContext
        var fetchedDealers: [DealerMO] = []
        do {
            fetchedDealers = try context.fetch(fetchRequest)
        } catch {
            print("Error checking duplicate dealer: \(error)")
        }
        
        // Zero Dealers returned. No duplicate
        if fetchedDealers.isEmpty { return false }
        
        // 1 or more dealers with same mobile numner
        // If this is not edit mode then duplicate
        guard let dealerToEdit = dealer else { return true }
        
        // Check the returned dealer is the same as the
        // dealer to edit. If so not duplicate
        // else duplicate
        let fetchedDealer = fetchedDealers.first!
        return fetchedDealer.objectID != dealerToEdit.objectID
    }
    
    private func showDuplicateAlert() {
        guard let window = view.window else { return }
        let alert = NSAlert()
        alert.messageText = "Duplicate Mobile Number"
        alert.informativeText = "Cannot add/update dealer. The mobile number provided is already associated with another dealer."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
}
