//
//  TableViewFetchedResultsControllerDataSource.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 22/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import CoreData

class TableViewFetchedResultsControllerDataSource<T: NSManagedObject>: NSObject, NSTableViewDataSource {
    private let tableView: NSTableView
    private let fetchedResultsController: NSFetchedResultsController<T>
    private let fetchedResultsControllerDelegate: TableViewFetchedResultsControllerDelegate
    
    public var selectedObject: T? {
        let selectedRow = tableView.selectedRow
        if selectedRow == -1 { return nil }
        
        return objectForRow(selectedRow)
    }
    
    public init(tableView: NSTableView,
                fetchRequest: NSFetchRequest<T>,
                context: NSManagedObjectContext) throws {
        // Hold reference to table view
        self.tableView = tableView
        
        // Delegate to update tableview when fetched results controller changes
        fetchedResultsControllerDelegate = TableViewFetchedResultsControllerDelegate(tableView: tableView)
        
        // Fetched results controller configuration
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = fetchedResultsControllerDelegate
        
        super.init()
        
        try fetchedResultsController.performFetch()
        tableView.dataSource = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    public func objectForRow(_ row: Int) -> T {
        let indexPath = IndexPath(item: row, section: 0)
        return fetchedResultsController.object(at: indexPath)
    }
}

