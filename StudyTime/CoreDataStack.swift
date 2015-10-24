//
//  CoreDataStack.swift
//  StudyTime
//
//  Created by Maximilian Litteral on 10/24/15.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    // Public
    
    // Stacks
    public static let sharedStack = CoreDataStack(modelName: "StudyTime", storeName: "StudyTime")
    
    // Contexts
    final public lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.coordinator
        context.name = "Main context"
        context.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType)
        context.performBlock { () -> Void in
            NSThread.currentThread().name = "Main Thread"
        }
        
        return context
    }()
    
    final public lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = self.coordinator
        backgroundContext.name = "Background context"
        backgroundContext.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType)
        backgroundContext.performBlock { () -> Void in
            NSThread.currentThread().name = "Background Thread"
        }
        
        return backgroundContext
    }()
    
    // Private
    private let modelName: String // "TVShows"
    private let storeName: String
    private var options: NSDictionary?
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        let url = CoreDataStack.applicationDocumentsDirectory().URLByAppendingPathComponent(self.storeName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: false,
            ]
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }
        catch let error as NSError {
            #if DEBUG
                print("Error adding persistent store: \(error)")
                abort()
            #endif
        }
        catch {
            #if DEBUG
                abort()
            #endif
        }
        
        return coordinator
    }()
    
    private lazy var model: NSManagedObjectModel = {
        let bundle = NSBundle(forClass: CoreDataStack.self)
        let modelURL = bundle.URLForResource(self.modelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    // MARK: - Init
    
    internal init(modelName: String, storeName: String, options: NSDictionary? = nil) {
        self.modelName = modelName
        self.storeName = storeName
        self.options = options
        
        // Notifications
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) { [weak self] (notification) -> Void in
            guard let sSelf = self else { return }
            
            if let object = notification.object as? NSManagedObjectContext {
                if object != sSelf.context {
                    sSelf.context.performBlock({ () -> Void in
                        sSelf.context.mergeChangesFromContextDidSaveNotification(notification)
                    })
                }
            }
        }
    }
    
    deinit {
        print("[♻️] Core Data Stack Deinitializing")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Class Actions
    
    class func applicationDocumentsDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        
        return urls[0]
    }
    
    // MARK: - Actions
    
    // TODO: Generalize the save function
    public func saveContext() {
        #if DEBUG
            assert(NSThread.currentThread().isMainThread == true, "Run on the main thread, \(NSThread.currentThread().description), \(NSThread.currentThread().isMainThread)")
        #endif
        
        if context.hasChanges {
            do {
                try context.save()
            }
            catch let error as NSError {
                #if DEBUG
                    print("Could not save: \(error)")
                    print("User info: \(error.userInfo)")
                #endif
            }
            catch {
                print("Failed to save context")
            }
        }
    }
    
    public func saveBackgroundContext() {
        #if DEBUG
            assert(NSThread.currentThread().isMainThread == false, "Run on the background thread thread, \(NSThread.currentThread().description), \(NSThread.currentThread().isMainThread)")
        #endif
        
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            }
            catch let error as NSError {
                #if DEBUG
                    print("Could not save: \(error)")
                    print("User info: \(error.userInfo)")
                #endif
            }
            catch {
                print("Failed to save background context")
            }
        }
    }
    
    // MARK: - Create contexts
    
    public func newPublicContext() -> NSManagedObjectContext {
        let newPublicContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        newPublicContext.persistentStoreCoordinator = coordinator
        newPublicContext.name = "New public context"
        newPublicContext.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType)
        
        return newPublicContext
    }
    
    public func newPrivateContext() -> NSManagedObjectContext {
        let newPrivateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        newPrivateContext.persistentStoreCoordinator = coordinator
        newPrivateContext.name = "New private context"
        newPrivateContext.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType)
        
        return newPrivateContext
    }
}