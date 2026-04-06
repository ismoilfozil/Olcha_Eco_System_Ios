//
//  StorageContainer.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 26/04/23.
//

import Foundation
import CoreData
import OlchaUtils

public class StorageContainer {
    public static let shared = StorageContainer()
    
    public init() {}
    
    // MARK: - Core Data stack
    public lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle(identifier: BundleType.olchaMarketModule.identifier)?.url(forResource: "MyDB", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Could not load data model")
        }
        
        let container = NSPersistentContainer(name: "MyDB", managedObjectModel: managedObjectModel)

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
