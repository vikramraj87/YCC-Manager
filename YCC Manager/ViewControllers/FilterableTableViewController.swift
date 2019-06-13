//
//  FilterableTableViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 27/05/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

extension NSUserInterfaceItemIdentifier {
    static let filterableContentCellIdentifier = NSUserInterfaceItemIdentifier("FilterableContentCell")
}

enum FilterMatch {
    case primaryMatch(NSRange)
    case secondaryMatch(NSRange)
}

protocol FilterableTableContent {
    var primaryField: String { get }
    var secondaryField: String { get }
}

protocol FilterableTableViewControllerDelegate: class {
    func didSelectItem(_ item: FilterableTableContent?)
}

class FilterableTableViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var textField: NSTextField!
    
    var data: [FilterableTableContent] = [] {
        didSet {
            textField?.stringValue = ""
            filtered = data.map { return ($0, nil) }
        }
    }
    var filtered: [(FilterableTableContent, FilterMatch?)] = []
    
    weak var delegate: FilterableTableViewControllerDelegate?
    
    private var queryString: String? {
        didSet {
            // To avoid sending multiple nil messages
            // Check whether the selected item is already nil
            if selectedItem != nil { selectedItem = nil }
            filterContent(for: queryString)
        }
    }
    
    private var selectedItem: FilterableTableContent? {
        didSet {
            delegate?.didSelectItem(selectedItem)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = try! readDealersDataFromPlist()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsMultipleSelection = false
        tableView.allowsEmptySelection = true
        
        textField.delegate = self
    }
    
    private func filterContent(for str: String?) {
        defer {
            tableView.reloadData()
        }
        
        guard let queryStr = str else {
            refreshFilteredContent()
            return
        }
        
        filtered = data.compactMap { item in
            let primaryStr = item.primaryField.lowercased() as NSString
            let primaryRange = primaryStr.range(of: queryStr)
            
            if primaryRange.lowerBound != NSNotFound {
                return (item, FilterMatch.primaryMatch(primaryRange))
            }
            
            let secondaryStr = item.secondaryField.lowercased() as NSString
            let secondaryRange = secondaryStr.range(of: queryStr)
            
            if secondaryRange.lowerBound != NSNotFound {
                return (item, FilterMatch.secondaryMatch(secondaryRange))
            }
            
            return nil
        }
    }
    
    // When no query string in the text field exists
    // filtered will be equal to the total content
    // with no range for each item to highlight
    private func refreshFilteredContent() {
        filtered = data.map { item in
            return (item, nil)
        }
    }
    
    private func itemForRow(_ row: Int) -> FilterableTableContent? {
        if row == -1 { return nil }
        
        let (item, _) = filtered[row]
        return item
    }
}

extension FilterableTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filtered.count
    }
}

extension FilterableTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: .filterableContentCellIdentifier, owner: self) else {
            print("Table view not able to make view")
            return nil
        }
        
        guard let filterableCell = cell as? FilterableContentCellView else {
            print("Cell view cannot be cast to FilterableContentCellView")
            return cell
        }
        
        let (item, match) = filtered[row]
        filterableCell.populateCellWith(item, matchData: match)
        return filterableCell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        
        selectedItem = itemForRow(selectedRow)
    }
}

extension FilterableTableViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        let str = self.textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        queryString = str.count > 0 ? str.lowercased() : nil
    }
}
