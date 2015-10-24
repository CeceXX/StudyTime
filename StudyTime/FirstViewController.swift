//
//  FirstViewController.swift
//  StudyTime
//
//  Created by Maximilian Litteral on 10/24/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UITableViewController {
    
    let coreDataStack = CoreDataStack.sharedStack
    
    var decks: [Stack] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getDecks()
        
        // Register cell
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func getDecks() {
        let context = coreDataStack.context
        
        let fetchRequest = NSFetchRequest(entityName: "Stack")
        
        do {
            if let stacks = try context.executeFetchRequest(fetchRequest) as? [Stack] {
                decks = stacks
                self.tableView.reloadData()
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func addDeck() {
        let alertController = UIAlertController(title: "Create a new deck", message: "Enter a name for the subject you will be studying", preferredStyle: .Alert)
        
        
        // Actions
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAlertAction)
        
        let createDeckAlertAction = UIAlertAction(title: "Create", style: .Default) { (action) -> Void in
            guard let textFields = alertController.textFields,
                textField = textFields.first else { return }
            
            self.createDeckWithName(textField.text ?? "")
        }
        alertController.addAction(createDeckAlertAction)
        
        // Text field
        alertController.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "Subject"
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func createDeckWithName(name: String) {
        guard name.characters.count > 0 else {
            return
        }
        
        // Create new deck
        let context = coreDataStack.context
        let entityDesc = NSEntityDescription.entityForName("Stack", inManagedObjectContext: context)
        let newStack = Stack(entity: entityDesc!, insertIntoManagedObjectContext: context)
        newStack.name = name
        
        coreDataStack.saveContext()
        
        self.tableView.beginUpdates()
        decks.append(newStack)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: decks.count-1, inSection: 0)], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let deck = decks[indexPath.row]
        cell.textLabel?.text = deck.name
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let deck = decks[indexPath.row]
        let alertController = UIAlertController(title: deck.name, message: nil, preferredStyle: .Alert)
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAlertAction)
        
        let freeModeAlertAction = UIAlertAction(title: "Free Mode", style: .Default) { (action) -> Void in
            
        }
        alertController.addAction(freeModeAlertAction)
        
        let correctnessModeAlertAction = UIAlertAction(title: "Correctness Mode", style: .Default) { (action) -> Void in
        
        }
        alertController.addAction(correctnessModeAlertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

