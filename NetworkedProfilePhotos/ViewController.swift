//
//  ViewController.swift
//  NetworkedProfilePhotos
//
//  Created by Eric Ludlow on 4/3/18.
//  Copyright © 2018 EricLudlow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonBackground: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Just a Button"
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        buttonBackground.layer.cornerRadius = 3.0
        buttonBackground.clipsToBounds = true
        
        settingsButton.layer.borderColor = UIColor.white.cgColor
        settingsButton.layer.borderWidth = 2.0
        settingsButton.layer.cornerRadius = 3.0
        settingsButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

