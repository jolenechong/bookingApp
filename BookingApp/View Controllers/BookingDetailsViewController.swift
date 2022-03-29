//
//  BookingDetailsViewController.swift
//  BookingApp
//
//  Created by Swift on 28/3/22.
//

import UIKit

class BookingDetailsViewController: UIViewController {
    
    var booking: Booking?

    @IBOutlet weak var bookingDateView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  format and display date
        if let b = booking {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
            let date = dateFormatter.string(from: b.date)

            bookingDateView.text = date
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showEdit")
        {
            let addBookingVC = segue.destination as!
            UpdateBookingViewController
            addBookingVC.booking = booking
        }
    }

}
