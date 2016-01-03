//
//  ViewController.swift
//  AwesomeButtonExample
//
//  Created by Панов Андрей on 26.12.15.
//  Copyright © 2015 Панов Андрей. All rights reserved.
//

import UIKit
import AwesomeButton

class ViewController: UIViewController {

    @IBOutlet weak var awesomeButton: AwesomeButton!
    @IBOutlet weak var someButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        someButton.setAttributedTitle(NSAttributedString(string: "NormaNSTextAttachmentContainerl", attributes: [:]), forState: .Normal)
        someButton.setAttributedTitle(NSAttributedString(string: "High", attributes: [:]), forState: .Highlighted)
        print(someButton.attributedTitleForState(.Highlighted))
        print(someButton.attributedTitleForState(.Selected))
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

