//
//  User.swift
//  BookingApp
//
//  Created by Swift on 23/3/22.
//

import UIKit

class User: NSObject {
    var name: String
    var email: String
    
    init(name: String, email: String)
    {
        self.name = name
        self.email = email
    }
}
