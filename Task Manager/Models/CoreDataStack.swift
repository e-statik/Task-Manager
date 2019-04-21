//
//  CoreDataStack.swift
//  Task Manager
//
//  Created by Victor Blokhin on 02/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName:String
    
    lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                print("Ошибка \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Ошибка \(error.localizedDescription)")
        }
    }
    
}
