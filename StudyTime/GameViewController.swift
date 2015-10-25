//
//  GameViewController.swift
//  StudyTime
//
//  Created by Andrew Walker on 24/10/2015.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit

enum GameType: Int {
    case FreeMode
    case CorrectnessMode
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
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
        
        cardTapped(false)
        
        if gameSelected == .CorrectnessMode {
            nextButton.enabled = true
            correctnessTextField.hidden = false
            cardGestureRegognizer.enabled = false
        }
        else if gameSelected == .FreeMode {
            nextButton.enabled = false
            correctnessTextField.hidden = true
            cardGestureRegognizer.enabled = true
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func shuffleArray<T>(var array: Array<T>) -> Array<T> {
        for var index = array.count - 1; index > 0; index-- {
            let randomNum = Int(arc4random_uniform(UInt32(index-1)))
            
            swap(&array[index], &array[randomNum])
        }
        return array
    }
    
    @IBAction func nextButtonTapped() {
        if correctnessTextField.text == cardArray[currentIndex].answer {
            cardTapped(true)
        }
    }
    
    @IBAction func cardTapped(animated: Bool) {
        cardArray = shuffleArray(deck.cards.array as! [Card])
        print(cardArray)
        
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
                    case .CorrectnessMode:
                        self.detailLabel.text = "Correct!"
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
