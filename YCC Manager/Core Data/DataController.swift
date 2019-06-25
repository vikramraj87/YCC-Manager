//
//  DataController.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 17/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation
import CoreData

enum PlistDataError: Error {
    case invalidFile
    case invalidData
}

class DataController {
    
    static let shared = DataController()
    
    private var persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "YCCData")
        persistentContainer.loadPersistentStores { [weak self] storeDescription, error in
            if let error = error {
                print("Cannot load stores due to error: \(error)")
            }
            self?.initializeData()
        }
    }
    
    func saveDefaultContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Cannot save context \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initializeData() {
        do {
            try loadInitialDealersData()
        } catch {
            print(error)
        }
        loadTags()
    }
    
    private func loadInitialDealersData() throws {
        let fetchRequest: NSFetchRequest<DealerMO> = DealerMO.fetchRequest()
        var dealers: [DealerMO] = []
        do {
            dealers = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching dealers: \(error)")
        }
        
        guard dealers.isEmpty else {
            print("Dealers not empty. No plist data loaded")
            return
        }
        
        print("Loading dealers data from plist file.")
        
        guard let fakeDealersDataPath = Bundle.main.path(forResource: "dealers", ofType: "plist") else {
            throw PlistDataError.invalidFile
        }
        
        guard let dealersData = NSArray(contentsOfFile: fakeDealersDataPath) as? [[String: String]] else {
            throw PlistDataError.invalidData
        }
        
        for data in dealersData {
            guard let name = data["Name"],
                let mobile = data["Mobile Number"] else {
                    print("Error reading dealer data")
                    continue
            }
            
            let dealer = DealerMO(context: viewContext)
            dealer.name = name
            dealer.mobileNumber = mobile
        }
        
        saveDefaultContext()
    }
    
    private func loadTags() {
        let fetchRequest: NSFetchRequest<TagMO> = TagMO.fetchRequest()
        var tags: [TagMO] = []
        do {
            tags = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching tags: \(error)")
        }
        
        guard tags.isEmpty else {
            print("Tags not empty. No data loaded")
            return
        }
        
        print("Creating tag entries")
        
        ["Ad stone", "Antique", "Matt", "Necklace",
         "Earring", "Jhumkha", "Pendant set", "Dual set",
         "Bridal set", "Oxidised", "Bracelet", "Combo set",
         "Haaram", "Hip chain", "Hip belt", "Bangle"].forEach { tagName in
            let tag = TagMO(context: viewContext)
            tag.tag = tagName
        }
        saveDefaultContext()
    }
}
