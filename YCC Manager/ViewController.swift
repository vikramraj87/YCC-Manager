//
//  ViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 01/05/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa



struct Dealer {
    var name: String
    var mobileNumber: String
}

extension Dealer: FilterableTableContent {
    var primaryField: String {
        return name
    }
    
    var secondaryField: String {
        return mobileNumber
    }
}

extension Dealer: CustomStringConvertible {
    var description: String {
        return "\(name) - \(mobileNumber)"
    }
}

func readDealersDataFromPlist() throws -> [Dealer] {
    guard let fakeDealersDataPath = Bundle.main.path(forResource: "dealers", ofType: "plist") else {
        throw PlistDataError.invalidFile
    }
    
    guard let dealersData = NSArray(contentsOfFile: fakeDealersDataPath) as? [[String: String]] else {
        throw PlistDataError.invalidData
    }
    
    let dealers = dealersData.compactMap { data -> Dealer? in
        guard let name = data["Name"],
            let mobile = data["Mobile Number"] else {
                print("Error reading dealer data")
                return nil
        }
        
        return Dealer(name: name, mobileNumber: mobile)
    }
    return dealers
}

//class ViewController: NSViewController {
//    @IBOutlet weak var filterableTableView: NSTableView!
//    @IBOutlet weak var filterField: NSTextField!
//    
//    var content: [FilterableTableContent] = []
//    var filtered: [(FilterableTableContent, FilterMatch?)] = []
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        content = try! readDealersDataFromPlist()
//        
//        refreshFilteredContent()
//        
//        filterField.stringValue = ""
//        
//        filterableTableView.dataSource = self
//        filterableTableView.delegate = self
//        
//        filterField.delegate = self
//    }
//
//    private func readDealersDataFromPlist() throws -> [Dealer] {
//        guard let fakeDealersDataPath = Bundle.main.path(forResource: "dealers", ofType: "plist") else {
//            throw PlistDataError.invalidFile
//        }
//        
//        guard let dealersData = NSArray(contentsOfFile: fakeDealersDataPath) as? [[String: String]] else {
//            throw PlistDataError.invalidData
//        }
//        
//        let dealers = dealersData.compactMap { data -> Dealer? in
//            guard let name = data["Name"],
//                let mobile = data["Mobile Number"] else {
//                    print("Error reading dealer data")
//                    return nil
//            }
//            
//            return Dealer(name: name, mobileNumber: mobile)
//        }
//        return dealers
//    }
//
//}
//
//extension ViewController: NSTableViewDataSource {
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return filtered.count
//    }
//}
//
//extension ViewController: NSTableViewDelegate {
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        guard let cell = tableView.makeView(withIdentifier: .filterableContentCellIdentifier, owner: self) else {
//            print("Table view not able to make view")
//            return nil
//        }
//        
//        guard let filterableCell = cell as? FilterableContentCellView else {
//            print("Cell view cannot be cast to FilterableContentCellView")
//            return cell
//        }
//        let (item, match) = filtered[row]
//        
//        guard let strongMatch = match else {
//            filterableCell.primaryField.stringValue = item.primaryField
//            filterableCell.secondaryField.stringValue = item.secondaryField
//            return filterableCell
//        }
//        
//        switch strongMatch {
//        case .primaryMatch(let range):
//            let attrString = NSMutableAttributedString(string: item.primaryField)
//            attrString.addAttribute(.backgroundColor, value: NSColor.blue, range: range)
//            filterableCell.primaryField.attributedStringValue = attrString
//            filterableCell.secondaryField.stringValue = item.secondaryField
//        case .secondaryMatch(let range):
//            let attrString = NSMutableAttributedString(string: item.secondaryField)
//            attrString.addAttribute(.backgroundColor, value: NSColor.blue, range: range)
//            filterableCell.primaryField.stringValue = item.primaryField
//            filterableCell.secondaryField.attributedStringValue = attrString
//        default:
//            filterableCell.primaryField.stringValue = item.primaryField
//            filterableCell.secondaryField.stringValue = item.secondaryField
//        }
//        
//        return filterableCell
//    }
//}
//
//extension ViewController: NSTextFieldDelegate {
//    func controlTextDidChange(_ obj: Notification) {
//        guard let textField = obj.object as? NSTextField,
//            textField == filterField else {
//                print("Not able to get the information")
//                return
//        }
//        
//        let filterText = textField.stringValue
//        
//        if filterText.count == 0 {
//            refreshFilteredContent()
//        } else {
//            filtered = filteredContent(for: filterText)
//        }
//        
//        filterableTableView.reloadData()
//    }
//    
//    private func filteredContent(for str: String) -> [(FilterableTableContent, FilterMatch?)] {
//        return content.compactMap { [weak self] item in
//            guard let strongSelf = self else { return nil }
//            
//            let match = strongSelf.isMatch(item: item, for: str)
//            
//            switch match {
//            case .noMatch:
//                return nil
//            default:
//                return (item, match)
//            }
//        }
//    }
//    
//    private func isMatch(item: FilterableTableContent, for str: String) -> FilterMatch {
//        let primaryStr = item.primaryField.lowercased() as NSString
//        let primaryRan = primaryStr.range(of: str.lowercased())
//        
//        if primaryRan.lowerBound != NSNotFound {
//            return FilterMatch.primaryMatch(primaryRan)
//        }
//        
//        let secondaryStr = item.secondaryField.lowercased() as NSString
//        let secondaryRan = secondaryStr.range(of: str.lowercased())
//        
//        if secondaryRan.lowerBound != NSNotFound {
//            return FilterMatch.secondaryMatch(secondaryRan)
//        }
//        
//        return FilterMatch.noMatch
//    }
//    
//    private func refreshFilteredContent() {
//        filtered = content.map { item in
//            return (item, nil)
//        }
//    }
//}
