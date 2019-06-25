//
//  AppDelegate.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 01/05/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import CoreData

extension NSStoryboard.Name {
    static let dealers = NSStoryboard.Name(stringLiteral: "Dealers")
    static let tags = NSStoryboard.Name(stringLiteral: "Tags")
}

extension NSStoryboard.SceneIdentifier {
    static let dealersWindowController = NSStoryboard.SceneIdentifier(stringLiteral: "DealersWindowController")
}



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var dealersWindowController: NSWindowController?
    var customersWindowController: NSWindowController?
    var tagsWindowController: NSWindowController?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func showDealers(_ sender: Any) {
        if dealersWindowController == nil {
            let sb = NSStoryboard(name: .dealers, bundle: nil)
            guard let dealersWC = sb.instantiateInitialController() as? NSWindowController else {
                return
            }
            dealersWindowController = dealersWC
        }
        
        if let windowController = dealersWindowController {
            windowController.showWindow(nil)
        }
    }
    
    @IBAction func showTags(_ sender: Any) {
        if tagsWindowController == nil {
            let sb = NSStoryboard(name: .tags, bundle: nil)
            guard let tagsWC = sb.instantiateInitialController() as? NSWindowController else {
                return
            }
            tagsWindowController = tagsWC
        }
        
        if let windowController = tagsWindowController {
            windowController.showWindow(nil)
        }
    }
}

