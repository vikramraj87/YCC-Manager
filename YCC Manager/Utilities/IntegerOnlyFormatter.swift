//
//  IntegerOnlyFormatter.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 16/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

class IntegerOnlyFormatter: NumberFormatter {
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if partialString.isEmpty { return true }
        
        if Int(partialString) != nil {
            return true
        }
        
        NSSound.beep()
        return false
    }
}
