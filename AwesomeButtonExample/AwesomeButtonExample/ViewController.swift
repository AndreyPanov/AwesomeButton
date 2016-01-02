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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //awesomeButton.setImages(normalImage: UIImage(named: "arrowNextDark")!, highlitedImage: UIImage(named: "arrowNext")!, selectedImage: UIImage(named: "arrowNext")!, imagePosition: .Left)
        //awesomeButton.setTitle(title: "Long long sentence", font: UIFont.systemFontOfSize(15.0))
        //awesomeButton.setupIT()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

