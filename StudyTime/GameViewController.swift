//
//  GameViewController.swift
//  StudyTime
//
//  Created by Andrew Walker on 24/10/2015.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit
import CoreData

enum GameType: Int {
    case FreeMode
    case CorrectnessMode
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var correctnessTextField: UITextField!
    @IBOutlet var cardGestureRegognizer: UITapGestureRecognizer!
    
    var cardArray: [Card] = []
    var coreDataStack: CoreDataStack!
    var deck: Stack!
    
    var currentIndex = -1
    
    var gameSelected: GameType = .FreeMode
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let data = deck.cards.array as! [Card]
        cardArray = data.shuffle()
        
        cardTapped(false)
        
        if gameSelected == .CorrectnessMode {
            correctnessTextField.hidden = false
            cardGestureRegognizer.enabled = false
        }
        else if gameSelected == .FreeMode {
            correctnessTextField.hidden = true
            cardGestureRegognizer.enabled = true
        }

        // Bar button items
        if gameSelected == .CorrectnessMode {
            let nextFlashcardBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "nextButtonTapped")
            self.navigationItem.rightBarButtonItem = nextFlashcardBarButtonItem
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonTapped() {
        if correctnessTextField.text == cardArray[currentIndex].answer {
            cardTapped(true)
        }
    }
    
    @IBAction func cardTapped(animated: Bool) {
        
        currentIndex++
        
        guard currentIndex != (cardArray.count * 2) else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if !animated {
            if currentIndex % 2 == 0 {
                
                UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                    self.detailLabel.text = self.cardArray[self.currentIndex / 2].hint
                    
                    
                    
                    }, completion: nil)
            }
            else {
                UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                    switch self.gameSelected {
                    case .FreeMode:
                        self.detailLabel.text = self.cardArray[self.currentIndex / 2].answer
                        
                        if self.gameSelected == .CorrectnessMode {
                            self.cardView.backgroundColor = UIColor.redColor()
                        }
                    case .CorrectnessMode:
                        self.detailLabel.text = "Correct!"
                        
                        if self.gameSelected == .CorrectnessMode {
                            self.cardView.backgroundColor = UIColor.greenColor()
                        }
                    }
                }, completion: nil)
            }
        }
        else {
            if currentIndex % 2 == 0 {
                detailLabel.text = cardArray[currentIndex / 2].hint
            }
            else {
                detailLabel.text = cardArray[currentIndex / 2].answer
            }
        }
    }

    @IBAction func endButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
