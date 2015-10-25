//
//  DemoAnswersViewController.swift
//  StudyTime
//
//  Created by Andrew Walker on 25/10/2015.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import UIKit

class DemoAnswersViewController: UIViewController {

    var currentHint = 0
    let hints = [
        "Coca-Cola",
        "HackingEDU",
        "Christmas"
    ]
    var hintValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func nextAnswer() {
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
        hintTitleLabel.text = "Answer"
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
        
        // Buttons
        let correctButton = UIButton(type: .System)
        correctButton.tintColor = UIColor.greenColor()
        correctButton.setTitle("Correct", forState: .Normal)
        correctButton.addTarget(self, action: "nextAnswer", forControlEvents: .TouchUpInside)
        correctButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(correctButton)
        
        let incorrectButton = UIButton(type: .System)
        incorrectButton.tintColor = UIColor.redColor()
        incorrectButton.setTitle("Incorrect", forState: .Normal)
        incorrectButton.addTarget(self, action: "nextAnswer", forControlEvents: .TouchUpInside)
        incorrectButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(incorrectButton)
        
        
        // Constraints
        var constraints: [NSLayoutConstraint] = []
        constraints.append(hintTitleLabel.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 200))
        constraints.append(hintValueLabel.topAnchor.constraintEqualToAnchor(hintTitleLabel.bottomAnchor, constant: 10))
        constraints.append(correctButton.topAnchor.constraintEqualToAnchor(hintValueLabel.bottomAnchor, constant: 10))
        constraints.append(incorrectButton.topAnchor.constraintEqualToAnchor(correctButton.bottomAnchor, constant: 10))
        
        
        constraints.append(hintTitleLabel.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor))
        constraints.append(hintTitleLabel.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor))
        constraints.append(hintValueLabel.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor))
        constraints.append(hintValueLabel.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor))
        constraints.append(correctButton.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor))
        constraints.append(correctButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor))
        constraints.append(incorrectButton.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor))
        constraints.append(incorrectButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor))
        self.view.addConstraints(constraints)
    }

}
