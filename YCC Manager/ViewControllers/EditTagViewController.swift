//
//  EditTagViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 25/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

extension NSStoryboard.SceneIdentifier {
    static let editTagViewController = NSStoryboard.SceneIdentifier(stringLiteral: "EditTagViewController")
}

protocol EditTagViewControllerDelegate: class {
    func addTagWithTagName(_ name: String)
    func updateTag(_ tag: TagMO, name: String)
}

class EditTagViewController: NSViewController {
    @IBOutlet var nameTextField: NSTextField!
    @IBOutlet var createUpdateButton: NSButton!
    
    weak var delegate: EditTagViewControllerDelegate?
    
    var tagToEdit: TagMO?
    
    var name: String = "" {
        didSet {
            validate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        createUpdateButton.isEnabled = false
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Reset
        createUpdateButton.title = "Create"
        nameTextField.stringValue = ""
        
        guard let tag = tagToEdit else { return }
        
        // Configure for editing
        createUpdateButton.title = "Update"
        
        nameTextField.stringValue = tag.tag
        name = tag.tag
    }
    
    @IBAction func createUpdate(_ sender: Any) {
        if let tag = tagToEdit {
            delegate?.updateTag(tag, name: name)
        } else {
            delegate?.addTagWithTagName(name)
        }
        dismiss(self)
    }
}

extension EditTagViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        
        name = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func validate() {
        createUpdateButton.isEnabled = name.count > 3
    }
}
