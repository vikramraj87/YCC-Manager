//
//  FilterableContentCellView.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 28/05/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

class FilterableContentCellView: NSTableCellView {
    
    @IBOutlet weak var primaryField: NSTextField!
    @IBOutlet weak var secondaryField: NSTextField!
    
    static let highlightColor = NSColor.selectedTextBackgroundColor

    override func prepareForReuse() {
        primaryField.stringValue = ""
        secondaryField.stringValue = ""
    }
    
    func populateCellWith(_ item: FilterableTableContent, matchData: FilterMatch?) {
        let primaryStr = NSMutableAttributedString(string: item.primaryField)
        let secondaryStr = NSMutableAttributedString(string: item.secondaryField)
        
        if let filterMatch = matchData {
            switch filterMatch {
            case .primaryMatch(let highlightRange):
                primaryStr.addAttribute(.backgroundColor,
                                        value: FilterableContentCellView.highlightColor,
                                        range: highlightRange)
            case .secondaryMatch(let highlightRange):
                secondaryStr.addAttribute(.backgroundColor,
                                          value: FilterableContentCellView.highlightColor,
                                          range: highlightRange)
            }
        }
        
        primaryField.attributedStringValue = primaryStr
        secondaryField.attributedStringValue = secondaryStr
    }
}
