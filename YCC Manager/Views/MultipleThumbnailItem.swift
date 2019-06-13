//
//  MultipleThumbnailItem.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 01/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import Combine

class MultipleThumbnailItem: NSCollectionViewItem {
    @IBOutlet private weak var thumbnailView: ImagesStackView!
    
    var thumbnails: [NSImage] = [] {
        didSet {
            thumbnailView.images = thumbnails
        }
    }
    
    static let selectionHighlightColor = NSColor.selectedControlColor.cgColor
    static let unselectedColor = NSColor.systemGray.withAlphaComponent(0.1).cgColor
    
    
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            handleHighlight()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            handleHighlight()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnails = []
        hideHighlight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = MultipleThumbnailItem.unselectedColor
        
        let doubleClickGesture = NSClickGestureRecognizer(target: self, action: #selector(onDoubleClick(_:)))
        doubleClickGesture.numberOfClicksRequired = 2
        doubleClickGesture.delaysPrimaryMouseButtonEvents = false
        
        view.addGestureRecognizer(doubleClickGesture)
    }
    
    @objc func onDoubleClick(_ sender: NSGestureRecognizer) {
        guard thumbnails.count > 1 else { return }
        
        
        guard let sb = NSStoryboard.main,
            let viewController = sb.instantiateController(withIdentifier: .multipleThumbnailPreviewController) as? MultipleThumbnailPreviewViewController else {
                print("Cannot instantiate preview view controller")
                return
        }
        
        guard let contentView = NSApp.mainWindow?.contentView else {
            print("Cannot get content view of main window")
            return
        }
        
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 400.0, height: 520.0)
            
        viewController.images = thumbnails
        popover.contentViewController = viewController
        
        let entryRect = self.view.convert(view.bounds, to: contentView)
        popover.show(relativeTo: entryRect, of: contentView, preferredEdge: .minY)
    }
    
    private func handleHighlight() {
        if isSelected {
            if highlightState == .forDeselection {
                hideHighlight()
            } else {
                showHighlight()
            }
        } else {
            if highlightState == .forSelection {
                showHighlight()
            } else {
                hideHighlight()
            }
        }
    }
    
    private func showHighlight() {
        view.layer?.backgroundColor = MultipleThumbnailItem.selectionHighlightColor
    }
    
    private func hideHighlight() {
        view.layer?.backgroundColor = MultipleThumbnailItem.unselectedColor
    }
}
