//
//  Booking.swift
//  BookingApp
//
//  Created by Swift on 23/3/22.
//

import UIKit

class Booking: NSObject {
    var id: String
    var current_date: Date
    var date: Date
    var ARTResult: Bool
    var image: String
    var email: String
    
    init(id: String,curr_date: Date, date: Date, ARTResult: Bool,image: String, email: String)
    {
        self.id = id
        self.current_date = curr_date
        self.date = date
        self.ARTResult = ARTResult
        self.image = image
        self.email = email
    }
}
