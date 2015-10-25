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
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var correctnessTextField: UITextField!
    
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
        }
        else if gameSelected == .FreeMode {
            correctnessTextField.hidden = true
            
            // Tap gesture recognizer
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.numberOfTouchesRequired = 1
            cardView.addGestureRecognizer(tapRecognizer)
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
        guard let guessText = correctnessTextField.text where guessText.characters.count > 0 else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.cardView.transform = CGAffineTransformMakeTranslation(-5, 0)
                }, completion: { (success) -> Void in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.cardView.transform = CGAffineTransformMakeTranslation(10, 0)
                        }, completion: { (success) -> Void in
                            UIView.animateWithDuration(0.5, animations: { () -> Void in
                                self.cardView.transform = CGAffineTransformIdentity
                                }, completion: { (success) -> Void in
                                    
                            })
                    })
            })
            return
        }
        
        if currentIndex % 2 == 0 {
            // New questions
            cardTapped(true)
        }
        else {
            // Check answer
            let answer = cardArray[currentIndex].answer
            if guessText.compare(answer, options: .CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedSame  {
                cardTapped(true, correct: true)
            }
            else {
                cardTapped(true, correct: false)
            }
        }
    }
    
    @IBAction func endButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func didTap(gestureRecognizer: UITapGestureRecognizer) {
        self.cardTapped(true)
    }
    
    func cardTapped(animated: Bool, correct: Bool? = nil) {
        self.dismissKeyboard(correctnessTextField)
        
        currentIndex++
        print("Current index: \(currentIndex)/\(cardArray.count * 2)")
        guard currentIndex != (cardArray.count * 2) else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if animated {
            if currentIndex % 2 == 0 {
                // New Question
                
                // Reset view
                cardView.backgroundColor = UIColor.whiteColor()
                
                // Reset text field
                correctnessTextField.enabled = true
                correctnessTextField.text = ""
                
                
                // Animate
                UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                    
                    self.typeLabel.text = "Hint"
                    self.detailLabel.text = self.cardArray[self.currentIndex / 2].hint

                    }, completion: { (success) -> Void in
                        if self.gameSelected == .CorrectnessMode {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.correctnessTextField.becomeFirstResponder()
                            })
                        }
                })

            }
            else {
                // Display answer
                correctnessTextField.enabled = false
                
                UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                    
                    self.typeLabel.text = "Answer"
                    
                    switch self.gameSelected {
                    case .FreeMode:
                        self.detailLabel.text = self.cardArray[self.currentIndex / 2].answer
                    case .CorrectnessMode:
                        if let correct = correct where correct == true {
                            self.detailLabel.text = "Correct!"
                            self.cardView.backgroundColor = UIColor.greenColor()
                        }
                        else {
                            let realAnswer = self.cardArray[self.currentIndex / 2].answer
                            self.detailLabel.text = "Incorrect! The answer was \"\(realAnswer)\""
                            self.cardView.backgroundColor = UIColor.redColor()
                        }
                    }
                }, completion: nil)
            }
        }
        else {
            if currentIndex % 2 == 0 {
                typeLabel.text = "Hint"
                detailLabel.text = cardArray[currentIndex / 2].hint
            }
            else {
                typeLabel.text = "Answer"
                detailLabel.text = cardArray[currentIndex / 2].answer
            }
        }
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
