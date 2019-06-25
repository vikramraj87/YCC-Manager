//
//  TableViewFetchedResultsControllerDelegate.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 22/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import CoreData

class TableViewFetchedResultsControllerDelegate: NSObject {
    let tableView: NSTableView
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        
        super.init()
    }
}

extension TableViewFetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Beginning updates")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Update type: \(type.rawValue)")
        
        switch type {
        case .insert:
            if let insertedIndexPath = newIndexPath {
                tableView.insertRows(at: IndexSet(integer: insertedIndexPath.item), withAnimation: .effectFade)
            }
        case .delete:
            if let deletedIndexPath = indexPath {
                tableView.removeRows(at: IndexSet(integer: deletedIndexPath.item), withAnimation: .effectFade)
            }
        case .update:
            if let updatedIndexPath = indexPath {
                tableView.reloadData(forRowIndexes: IndexSet(integer: updatedIndexPath.item),
                                            columnIndexes: IndexSet(integersIn: 0..<tableView.numberOfColumns))
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Finishing updates")
        tableView.endUpdates()
    }
}
