//
//  AvailabilityViewController.swift
//  BookingApp
//
//  Created by Swift on 28/3/22.
//

import UIKit

class AvailabilityViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var labelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.text = "Select a date"

    }
    
    @IBAction func datePickerSelected(_ sender: Any) {
        DataManager.loadAvailability(original_date: datePicker.date){
            action in
            
            if action == 0 {
                self.labelView.text = "No Bookings"
            }else{
                let percentageFilled = (Double(action)/Double(Constants.Storyboard.totalEmployees)) * Double(100)
                self.labelView.text = "Slots Filled: \(percentageFilled.rounded())%"
            }
        }
    }
    
    

}
