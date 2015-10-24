//
//  DeckSelectorViewController.swift
//  StudyTime
//
//  Created by Maximilian Litteral on 10/24/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit
import CoreData

protocol DeckSelectorViewControllerDelegate: class {
    func deckSelectorViewController(viewController: DeckSelectorViewController, selectedDeck: Stack)
}

class DeckSelectorViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    weak var delegate: DeckSelectorViewControllerDelegate?
    var decks: [Stack] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select study deck to use"
        
        // Bar button item
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem

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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let deck = decks[indexPath.row]
        cell.textLabel?.text = deck.name

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let deck = decks[indexPath.row]
        self.delegate?.deckSelectorViewController(self, selectedDeck: deck)
    }

}
