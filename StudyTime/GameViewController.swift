//
//  GameViewController.swift
//  StudyTime
//
//  Created by Andrew Walker on 24/10/2015.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var detailLabel: UILabel!
    
    var cardArray: [Card] = []
    var coreDataStack: CoreDataStack!
    var deck: Stack!
    
    func shuffleArray<T>(var array: Array<T>) -> Array<T> {
        for var index = array.count - 1; index > 0; index-- {
            let j = Int(arc4random_uniform(UInt32(index-1)))
        
            swap(&array[index], &array[j])
        }
        return array
    }
    
    @IBAction func cardTapped(sender: AnyObject) {
        detailLabel.text = cardArray.first?.answer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray = shuffleArray(Array(deck.cards))
        detailLabel.text = cardArray.first?.hint

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
