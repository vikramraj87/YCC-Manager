//
//  SelectDealerViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 30/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

protocol SelectDealerViewControllerDelegate: class {
    func didSelectDealer(_ dealer: DealerMO)
}

class SelectDealerViewController: NSViewController {
    
    @IBOutlet var actionButton: NSButton!
    @IBOutlet var tableView: NSTableView!
    
    var dataSource: TableViewFetchedResultsControllerDataSource<DealerMO>?
    
    weak var delegate: SelectDealerViewControllerDelegate?
    
    var actionTitle: String = "" {
        didSet {
            actionButton?.title = actionTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        configDataSource()
    }
    
    override func viewDidAppear() {
        actionButton.isEnabled = false
        actionButton?.title = actionTitle
    }
    
    @IBAction func selectDealer(_ sender: Any) {
        guard tableView.selectedRow != -1 else { return }
        
        guard let dataSource = self.dataSource else { return }
        
        let dealer = dataSource.objectForRow(tableView.selectedRow)
        delegate?.didSelectDealer(dealer)
        dismiss(sender)
    }
    
    @IBAction func filterDealer(_ sender: NSSearchField) {
        guard !sender.stringValue.isEmpty else {
            try? dataSource?.applyPredicate(nil)
            return
        }
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "name CONTAINS[c] %@", sender.stringValue),
            NSPredicate(format: "mobileNumber CONTAINS %@", sender.stringValue)
        ])
        
        
        try! dataSource?.applyPredicate(predicate)
    }
    
    private func configTableView() {
        tableView.delegate = self
        
        tableView.allowsEmptySelection = true
        tableView.allowsColumnSelection = false
        tableView.allowsMultipleSelection = false
    }
    
    private func configDataSource() {
        let fetchRequest = DealerMO.nameSortedFetchRequest
        
        // Get context
        let context = DataController.shared.viewContext
        
        // Initialize the data source
        do {
            dataSource = try TableViewFetchedResultsControllerDataSource(tableView: tableView,
                                                                         fetchRequest: fetchRequest,
                                                                         context: context)
        } catch {
            print("Error loading data source for dealers: \(error)")
        }
    }
}

extension SelectDealerViewController: NSTableViewDelegate {
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
        } else {
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
        actionButton.isEnabled = (tableView.selectedRow != -1)
    }
}
