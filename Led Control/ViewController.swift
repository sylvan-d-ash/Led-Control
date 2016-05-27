//
//  ViewController.swift
//  Led Control
//
//  Created by Sylvan .D. Ash on 1/15/16.
//  Copyright © 2016 Daitensai. All rights reserved.
//

import UIKit
//import Foundation


let SETTINGS_FILENAME = "LEDUserSettings.plist"

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate, SettingsViewControllerDelegate {

    @IBOutlet weak var stateSwitcher: UISegmentedControl!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var patternPicker: UIPickerView!
    @IBOutlet weak var myWebView: UIWebView!
    
    let colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"]
    let patterns = ["No pattern", "Color wipe", "Chase", "Theater", "Rainbow"]
    
    var color = 0
    var pattern = 0
    var url = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorPicker.dataSource = self
        patternPicker.dataSource = self
        
        colorPicker.delegate = self
        patternPicker.delegate = self
        
        myWebView.delegate = self
        
        // Load user settings
        loadSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showSettings") {
            let vc = segue.destinationViewController as! SettingsViewController
            vc.delegate = self
        }
    }
    
    // MARK: IB actions

    @IBAction func sendToDevice(sender: AnyObject) {
        var state = 0
        if (stateSwitcher.selectedSegmentIndex == 0) {
            state = 1
        }
        
        /// A string with the arduino url plus the message to send.
        /// The message starts with a '$' and ends with a '*'
        let message = "\(url)/$\(state)C\(color)P\(pattern)*"
        
        /// The message as a URL
        let webUrl = NSURL(string: message)
        
        // Display an error if URL incorrectly configured
        if (url == "" || webUrl == nil) {
            let alertController = UIAlertController(title: "Error", message: "Invalid or no URL entered!", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let request = NSURLRequest(URL: webUrl!)
        myWebView.loadRequest(request)
        //myWebView.
    }

    
    // MARK: - UIPicker Delegate and DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return colors.count
        }
        
        return patterns.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return colors[row]
        }
        
        return patterns[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            color = row
        } else if pickerView.tag == 1 {
            pattern = row
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("loading about to start..")
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("loading has started...")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("loading completed")
    }
    
    
    // MARK: - SettingsViewController Delegate
    
    func settingsViewControllerDidFinish(controller: SettingsViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // save our settings - the flipside view controller already updated our instance variables by using the delegate
        saveSettings()
    }
    
    
    // MARK: - Private
    
    /**
     Returns the URL path to the application's Documents directory 
     */
    func applicationDocumentsDirectory() -> NSURL {
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
        return documentDirectoryURL
    }
    
    /**
     Load the user's settings in a plist file in the Documents directory for this application
     */
    func loadSettings() -> Bool {
        let documentsPath = applicationDocumentsDirectory()
        let documentsURL = documentsPath.URLByAppendingPathComponent(SETTINGS_FILENAME)

        /// Values from the plist file
        let readValues = NSDictionary(contentsOfURL: documentsURL)
        
        // Set the values
        if let dictValues = readValues {
            url = dictValues["URL"] as! String
            
            return true
        }
        
        // If no values, then set defaults
        url = "http://127.0.0.1"
        
        // Save the new defaults
        saveSettings()
        
        return false
    }
    
    /**
     Save the user's settings in a plist file in the Documents directory for this application
     */
    func saveSettings() {
        let documentsPath = applicationDocumentsDirectory()
        let documentsURL = documentsPath.URLByAppendingPathComponent(SETTINGS_FILENAME)
        
        /// The values to save
        let savedValues: NSDictionary = [ "URL": self.url]
        
        // Save the values to plist
        savedValues.writeToURL(documentsURL, atomically: true)
    }
}

