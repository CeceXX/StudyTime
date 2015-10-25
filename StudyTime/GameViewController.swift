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
    
    // Game states
    var currentIndex = 0 {
        didSet {
            print("Current index is now: \(currentIndex), total number of questions is: \(cardArray.count)")
        }
    }
    var gameSelected: GameType = .FreeMode
    var showingAnswer = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let data = deck.cards.array as! [Card]
        cardArray = data.shuffle()
        
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
            
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "didTap:")
            swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
            cardView.addGestureRecognizer(swipeRecognizer)
        }

        // Bar button items
        if gameSelected == .CorrectnessMode {
            let nextFlashcardBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "nextButtonTapped")
            self.navigationItem.rightBarButtonItem = nextFlashcardBarButtonItem
        }
        
        // Start the game
        displayNextQuestion(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    /// Used to check answers
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
        
        if showingAnswer {
            // New questions
            currentIndex++
            showingAnswer = false
            
            // Display next question
            cardTapped(true)
        }
        else {
            showingAnswer = true
            
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
    
    /// Tap to next guestion
    func didTap(gestureRecognizer: UITapGestureRecognizer) {
        if showingAnswer {
            // New questions
            currentIndex++
            showingAnswer = false
        }
        else {
            showingAnswer = true
        }
        self.cardTapped(true)
    }
    
    func cardTapped(animated: Bool, correct: Bool? = nil) {
        self.dismissKeyboard(correctnessTextField)
        
        guard currentIndex != cardArray.count else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if animated {
            if showingAnswer == false {
                // New Question
                displayNextQuestion(animated)
            }
            else {
                // Answer
                displayAnswer(animated, correct: correct)
            }
        }
        else {
            if showingAnswer == false {
                displayNextQuestion(animated)
            }
            else {
                displayAnswer(animated, correct: correct)
            }
        }
    }
    
    func displayNextQuestion(animated: Bool) {
        // Reset view
        cardView.backgroundColor = UIColor.whiteColor()
        
        // Reset text field
        correctnessTextField.enabled = true
        correctnessTextField.text = ""
        
        let newHint = cardArray[currentIndex].hint
        
        if animated {
            // Animate
            UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                
                self.typeLabel.text = "Hint"
                self.detailLabel.text = newHint
                
                }, completion: { (success) -> Void in
                    if self.gameSelected == .CorrectnessMode {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.correctnessTextField.becomeFirstResponder()
                        })
                    }
            })
        }
        else {
            typeLabel.text = "Hint"
            detailLabel.text = newHint
        }
    }
    
    func displayAnswer(animated: Bool, correct: Bool? = nil) {
        
        // Display answer
        correctnessTextField.enabled = false
        
        let answer = cardArray[currentIndex].answer
        
        if animated {
            UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                
                self.typeLabel.text = "Answer"
                
                switch self.gameSelected {
                case .FreeMode:
                    self.detailLabel.text = answer
                case .CorrectnessMode:
                    if let correct = correct where correct == true {
                        self.detailLabel.text = "Correct!"
                        self.cardView.backgroundColor = UIColor.greenColor()
                    }
                    else {
                        self.detailLabel.text = "Incorrect! The answer was \"\(answer)\""
                        self.cardView.backgroundColor = UIColor.redColor()
                    }
                }
                }, completion: nil)
        }
        else {
            typeLabel.text = "Answer"
            detailLabel.text = answer
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
