//
//  EditDealerViewController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 16/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

extension NSStoryboard.SceneIdentifier {
    static let editDealerViewController = NSStoryboard.SceneIdentifier(stringLiteral: "EditDealerViewController")
}

protocol EditDealerViewControllerDelegate: class {
    func addDealerWithName(_ name: String, mobileNumber: String)
    func updatedDealer(_ dealer: DealerMO, name: String, mobileNumber: String)
}

class EditDealerViewController: NSViewController {
//    private var dealersViewController: DealersViewController!
    
    @IBOutlet var nameTextField: NSTextField!
    @IBOutlet var mobileTextField: NSTextField!
    @IBOutlet var createEditButton: NSButton!
    
    weak var delegate: EditDealerViewControllerDelegate?
    
    var dealerToEdit: DealerMO?
    
    var name: String = "" {
        didSet {
            validate()
        }
    }
    
    var mobileNumber: String = "" {
        didSet {
            validate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        mobileTextField.delegate = self
        mobileTextField.formatter = IntegerOnlyFormatter()
        
        createEditButton.isEnabled = false
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        createEditButton.title = "Create"
        nameTextField.stringValue = ""
        mobileTextField.stringValue = ""
        
        guard let dealer = dealerToEdit else { return }
        
        // Configure for editing
        createEditButton.title = "Update"
        
        nameTextField.stringValue = dealer.name
        mobileTextField.stringValue = dealer.mobileNumber
        
        name = dealer.name
        mobileNumber = dealer.mobileNumber
    }
    
    @IBAction func createUpdate(_ sender: Any) {
        if let dealer = dealerToEdit {
            delegate?.updatedDealer(dealer, name: name, mobileNumber: mobileNumber)
        } else {
            delegate?.addDealerWithName(name, mobileNumber: mobileNumber)
        }
        dismiss(self)
    }
}

extension EditDealerViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        
        if textField == nameTextField {
            name = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textField == mobileTextField {
            mobileNumber = textField.stringValue
        }
    }
    
    private func validate() {
        if name.count > 4 && mobileNumber.count > 5 {
            createEditButton.isEnabled = true
        } else {
            createEditButton.isEnabled = false
        }
        
    }
}
