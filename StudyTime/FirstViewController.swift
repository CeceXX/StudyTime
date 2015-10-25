//
//  FirstViewController.swift
//  StudyTime
//
//  Created by Maximilian Litteral on 10/24/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit
import CoreData
import MultipeerConnectivity

class FirstViewController: UITableViewController {
    
    let coreDataStack = CoreDataStack.sharedStack
    
    var decks: [Stack] = []
    
    // Multipeer
    var session: MCSession!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getDecks()
        
        // Multipeer
        let peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
        browser = MCBrowserViewController(serviceType: "StudyTime", session: session)
//        browser.minimumNumberOfPeers = 1
        browser.maximumNumberOfPeers = 1
        browser.delegate = self
        
        assistant = MCAdvertiserAssistant(serviceType: "StudyTime", discoveryInfo: nil, session: session)
        assistant.start()
        
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
    
    @IBAction func lookForPlayers() {
        
        self.presentViewController(browser, animated: true, completion: nil)
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
        
        if deck.cards.count == 0 {
            let cardManager = CardManagerViewController()
            cardManager.coreDataStack = self.coreDataStack
            cardManager.deck = deck
            let navController = UINavigationController(rootViewController: cardManager)
            self.presentViewController(navController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: deck.name, message: nil, preferredStyle: .ActionSheet)
            
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAlertAction)
            
            let freeModeAlertAction = UIAlertAction(title: "Free Mode", style: .Default) { (action) -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gameView = storyboard.instantiateViewControllerWithIdentifier("gameView") as! GameViewController
                gameView.coreDataStack = self.coreDataStack
                gameView.deck = deck
                self.presentViewController(gameView, animated: true, completion: nil)
            }
            alertController.addAction(freeModeAlertAction)
            
            let correctnessModeAlertAction = UIAlertAction(title: "Correctness Mode", style: .Default) { (action) -> Void in
                
            }
            alertController.addAction(correctnessModeAlertAction)
            
            let editCardsAlertAction = UIAlertAction(title: "Edit Cards", style: .Default) { (action) -> Void in
                let cardManager = CardManagerViewController()
                cardManager.coreDataStack = self.coreDataStack
                cardManager.deck = deck
                let navController = UINavigationController(rootViewController: cardManager)
                self.presentViewController(navController, animated: true, completion: nil)
            }
            alertController.addAction(editCardsAlertAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}

extension FirstViewController: MCSessionDelegate {
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        print("change state with: \(peerID.displayName)")
        
        if state == .Connected {
            
        }
    }
    
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
        print("Received certificate from: \(peerID.displayName)")
        certificateHandler(true)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        print("Received data from: \(peerID.displayName)")
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Received stream from: \(peerID.displayName)")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        print("Receiving resource from: \(peerID.displayName)")
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        print("Received resource from: \(peerID.displayName)")
    }
}

extension FirstViewController: MCBrowserViewControllerDelegate {
    func browserViewController(browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        print("Browser did finish")
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
        
        let deckSelector = DeckSelectorViewController()
        let navController = UINavigationController(rootViewController: deckSelector)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        print("Browser was cancelled")
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}