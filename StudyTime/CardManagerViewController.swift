//
//  StackViewController.swift
//  StudyTime
//
//  Created by Maximilian Litteral on 10/24/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit
import CoreData

class CardManagerViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var deck: Stack!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = deck.name
        
        // Bar button items
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
        
        let addCardBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addCard")
        self.navigationItem.leftBarButtonItem = addCardBarButtonItem
        
        
        // Register cell
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func done() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addCard() {
        let alertController = UIAlertController(title: "Create a new flash card", message: "Enter the hint to be given and the answer.", preferredStyle: .Alert)
        
        
        // Actions
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAlertAction)
        
        let createDeckAlertAction = UIAlertAction(title: "Add", style: .Default) { (action) -> Void in
            guard let textFields = alertController.textFields,
                hintTextFieldText = textFields[0].text,
                answerTextFieldText = textFields[1].text else { return }
            
            self.addFlashcardWithHint(hintTextFieldText, answer: answerTextFieldText)
        }
        alertController.addAction(createDeckAlertAction)
        
        // Text fields
        alertController.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "Hint"
        }
        alertController.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "Answer"
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addFlashcardWithHint(hint: String, answer: String) {
        
        // Create new deck
        let context = coreDataStack.context
        let entityDesc = NSEntityDescription.entityForName("Card", inManagedObjectContext: context)
        let newCard = Card(entity: entityDesc!, insertIntoManagedObjectContext: context)
        newCard.hint = hint
        newCard.answer = answer
        newCard.stack = deck
        
        coreDataStack.saveContext()
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.cards.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let card = deck.cards[deck.cards.startIndex.advancedBy(indexPath.row)]
        cell.textLabel?.text = card.hint

        return cell
    }
}
