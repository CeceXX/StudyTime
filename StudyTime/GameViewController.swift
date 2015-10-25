//
//  GameViewController.swift
//  StudyTime
//
//  Created by Andrew Walker on 24/10/2015.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var cardArray: [Card] = []
    var coreDataStack: CoreDataStack!
    var deck: Stack!
    
    var currentIndex = -1
    
    enum GameType {
        case FreeMode
        case CorectnessMode
    }
    
    var gameSelected: GameType!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardTapped(false)

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
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func cardTapped(animated: Bool) {
        cardArray = shuffleArray(Array(deck.cards))
        
        currentIndex++
        
        if currentIndex != (cardArray.count * 2) {
            if currentIndex % 2 == 0 {
                if animated {
                    detailLabel.text = cardArray[currentIndex / 2].hint
                }
                else {
                    UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                        self.detailLabel.text = self.cardArray[self.currentIndex / 2].hint
                    }, completion: nil)
                }
            }
            else {
                if animated {
                    detailLabel.text = cardArray[currentIndex / 2].answer
                }
                else {
                    UIView.transitionWithView(cardView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                        self.detailLabel.text = self.cardArray[self.currentIndex / 2].answer
                    }, completion: nil)
                }
            }
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func endButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
