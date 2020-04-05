//
//  CoreDataManager.swift
//  GHUserList
//
//  Created by wtildestar on 30/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import CoreData

struct PersistenceService {
    
    private init() {}
    static let shared = PersistenceService()
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GHUserListModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError( "Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchUsers() -> [User] {
        print("Trying to fetch users")
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
//        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        
        do {
            let users = try context.fetch(fetchRequest)
            return users
            
        } catch let fetchErr {
            print("Failed to fetch users:", fetchErr)
            return []
        }
    }
    
    // MARK: - Core Data Saving support
    
    func save() {
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
