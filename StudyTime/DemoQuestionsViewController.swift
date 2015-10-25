//
//  DemoQuestionsViewController.swift
//  StudyTime
//
//  Created by Andrew Walker on 25/10/2015.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit

class DemoQuestionsViewController: UIViewController {
    
    var currentHint = 0
    let hints = [
        "Red canned soda",
        "hackathon this weekend",
        "holiday in december"
    ]
    var hintValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        // Do any additional setup after loading the view.
        setup()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func tapGesture(tapGesture: UITapGestureRecognizer) {
        currentHint++
        
        if currentHint >= hints.count {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        hintValueLabel.text = hints[currentHint]
    }
    
    // MARK: Setup
    
    func setup() {
        
        let hintTitleLabel = UILabel()
        hintTitleLabel.text = "Hint"
        hintTitleLabel.textAlignment = .Center
        hintTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        hintTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hintTitleLabel)
        
        hintValueLabel = UILabel()
        hintValueLabel.text = hints[currentHint]
        hintValueLabel.textAlignment = .Center
        hintValueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        hintValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hintValueLabel)
        
        
        // Constraints
        var constraints: [NSLayoutConstraint] = []
        constraints.append(hintTitleLabel.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 200))
        constraints.append(hintValueLabel.topAnchor.constraintEqualToAnchor(hintTitleLabel.bottomAnchor, constant: 10))
        
        
        constraints.append(hintTitleLabel.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor))
        constraints.append(hintTitleLabel.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor))
        constraints.append(hintValueLabel.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor))
        constraints.append(hintValueLabel.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor))
        self.view.addConstraints(constraints)
    }

}
