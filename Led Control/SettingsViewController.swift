//
//  SettingsViewController.swift
//  Led Control
//
//  Created by Sylvan .D. Ash on 1/16/16.
//  Copyright © 2016 Daitensai. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsViewControllerDidFinish(controller: SettingsViewController)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    // Delegate to use to pass back the settings
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get reference to main View Controller
        let vc = self.delegate as! ViewController
        
        // Set the default URL value as stored in user's settings
        urlTextField.text = vc.url
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonDidPress(sender: AnyObject) {
        if let _ = self.delegate {
            let vc = self.delegate as! ViewController
            vc.url = self.urlTextField!.text!
            vc.settingsViewControllerDidFinish(self)
        }
    }
}