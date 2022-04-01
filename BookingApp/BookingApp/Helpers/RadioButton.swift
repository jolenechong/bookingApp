//
//  RadioButton.swift
//  BookingApp
//
//  Created by Swift on 22/3/22.
//

import UIKit

class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
//        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                self.layer.borderColor = "f9f9f9"
//            } else {
//                self.layer.borderColor = "000000"
//            }
//        }
//    }
}
