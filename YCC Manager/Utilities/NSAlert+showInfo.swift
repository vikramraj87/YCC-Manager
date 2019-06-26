//
//  NSAlert+showInfo.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 26/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa


extension NSAlert {
    public class func showInfo(message: String, detail: String, window: NSWindow) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = detail
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
}
