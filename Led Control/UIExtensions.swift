//
//  UIExtensions.swift
//  Led Control
//
//  Created by Sylvan .D. Ash on 1/16/16.
//  Copyright © 2016 Daitensai. All rights reserved.
//

import UIKit

extension UITextField {
    /**
     Action for done button
     */
    func doneButtonDidPress(sender: AnyObject) {
        self.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField : UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}