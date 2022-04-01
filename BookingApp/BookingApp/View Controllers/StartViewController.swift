//
//  StartViewController.swift
//  BookingApp
//
//  Created by Swift on 23/3/22.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the elements
        Utilities.styleHollowButton(signUpButton)
        Utilities.styleFilledButton(loginButton)

    }
}
