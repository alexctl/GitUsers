//
//  DataController.swift
//  GitUsers
//
//  Created by Alexandre Cantal on 23/07/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
import CoreData

struct DataController {
    
    static let `default` = DataController()
    
    private var managedObjectContext: NSManagedObjectContext
    
    private init() {
        
        guard let modelURL = Bundle.main.url(forResource: "UserDatabase", withExtension: "momd") else {
            fatalError("Error Ressource Database")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error Content")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = urls[urls.endIndex - 1]
        let storeUrl = docUrl.appendingPathComponent("UserDatabase.sqlite")
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch {
            fatalError("error Persisten Store")
        }
    }
    
    func users() -> [Users] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        //let title = NSSortDescriptor(key: "name", ascending: true)
        //        let nbProductsDescriptor = NSSortDescriptor(key: "numberOfProducts", ascending: true)
        //
        //        request.sortDescriptors = [nbProductsDescriptor, nameDescriptor]
        //
        do {
            guard let movies = try managedObjectContext.fetch(request) as? [Users] else {
                return []
            }
            
            return movies
        } catch {
            return []
        }
    }
    
    func newObject(_ className: String) -> AnyObject {
        return NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext)
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("oups: cannot save")
        }
    }
    
    func delete(deleterow : NSManagedObject) {
        
        do {
            managedObjectContext.delete(deleterow)
            try managedObjectContext.save()
        } catch {
            fatalError("oups: cannot save")
        }
    }
    
    func userExist(id: Int) ->Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        var userCount = 0
        
        do {
            userCount = try managedObjectContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return userCount == 0
    }
    
}
