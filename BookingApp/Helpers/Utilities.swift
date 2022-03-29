//
//  Utilities.swift
//  BookingApp
//
//  Created by Swift on 23/3/22.
//

import Foundation
import UIKit

class Utilities {
    
//    static func styleTextField(_ textfield:UITextField) {
//
//        // Create the bottom line
//        let bottomLine = CALayer()
//
//        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
//
//        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
//
//        // Remove border on text field
//        textfield.borderStyle = .none
//
//        // Add the line to the text field
//        textfield.layer.addSublayer(bottomLine)
//
//    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 243/255, green: 78/255, blue: 90/255, alpha: 1.0)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 243/255, green: 78/255, blue: 90/255, alpha: 1.0).cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.init(red: 243/255, green: 78/255, blue: 90/255, alpha: 1.0)
    }
    
    static func styleTagLabel(_ label:UILabel) {
        label.textColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 100/100, alpha: 1.0)
        label.layer.cornerRadius = 5.0
        label.layer.backgroundColor = UIColor(hue: 220/360, saturation: 32/100, brightness: 26/100, alpha: 1.0).cgColor
        
//        let padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
//        label.drawText(in: CGRect(x: 0, y: 0, width: 100, height: 100).inset(by:padding))
    }
    
//    static func isPasswordValid(_ password : String) -> Bool {
//
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//        return passwordTest.evaluate(with: password)
//    }
    
}
