//
//  Utilities.swift
//  BookingApp
//
//  Created by Swift on 23/3/22.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 243/255, green: 78/255, blue: 90/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 243/255, green: 78/255, blue: 90/255, alpha: 1.0).cgColor
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.init(red: 243/255, green: 78/255, blue: 90/255, alpha: 1.0)
    }
    
    static func styleTagLabel(_ label:UILabel) {
        label.textColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 100/100, alpha: 1.0)
        label.layer.cornerRadius = 5.0
        label.layer.backgroundColor = UIColor(hue: 220/360, saturation: 32/100, brightness: 26/100, alpha: 1.0).cgColor
    }
    
}
