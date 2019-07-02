//
//  ImportProgressViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 01/07/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

class ImportProgressViewController: NSViewController {
    @IBOutlet var progressStatusLabel: NSTextField!
    @IBOutlet var progressBar: NSProgressIndicator!
    @IBOutlet var currentActionLabel: NSTextField!
    
    var items: [ImportItem] = []
    var selectedDealer: DealerMO?
    
    var isCopy = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        progressBar.minValue = 0
        progressBar.maxValue = Double(items.count)
        
        performImport()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        items = []
        selectedDealer = nil
    }
    
    func performImport() {
        guard items.count > 0 else {
            print("Items empty")
            return
        }
        
        guard let dealer = selectedDealer else {
            print("Dealer nil")
            return
        }
        
        for (idx, item) in items.enumerated() {
            progressStatusLabel.stringValue = "Importing Jewel \(idx + 1)/\(items.count)"
            
            currentActionLabel.stringValue = "Creating Jewel"
            // Create jewel object
            // Assign dealer to jewel object
            
            let fileAction = isCopy ? "Copying" : "Moving"
            currentActionLabel.stringValue = "\(fileAction) images"
            
            for _ in item.imageURLs {
                // Move the image to app destination
                // store the new url in the image mo
                // link image mo to jewel
                // Append the image to images array
                // save image
            }
            
            currentActionLabel.stringValue = "Applying tags"
            // Link jewel to item.tags
            
            // Increment progress
            progressBar.doubleValue += 1
        }
        
        // After everything
//        DataController.shared.saveDefaultContext()
//        dismiss(self)
    }
}
