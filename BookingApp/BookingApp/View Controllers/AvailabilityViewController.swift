//
//  AvailabilityViewController.swift
//  BookingApp
//
//  Created by Swift on 28/3/22.
//

import UIKit

class AvailabilityViewController: UIViewController {

    @IBOutlet weak var percentageView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        percentageView.text = ""
        dateView.text = "Select a date above to view availability"
    }
    
    @IBAction func datePickerSelected(_ sender: Any) {
        DataManager.loadAvailability(original_date: datePicker.date){
            action in
            // reset to 0
            self.percentageView.text = "0%"

            // when date is clicked, display availability
            if action == 0 {
                self.percentageView.text = "0%"
            }else{
                let percentageFilled = (Double(action)/Double(Constants.Storyboard.totalEmployees)) * Double(100)
                
                if percentageFilled.rounded() < 50 {
                    // cuz max 50
                    self.percentageView.text = "\(50 + percentageFilled.rounded())%"
                }
                else{
                    self.percentageView.text = "Full "
                }
            }
            
            // update to say date picked
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            let nowDate = dateFormatter.string(from:self.datePicker.date)
            self.dateView.text = "for \(nowDate)"
        }
    }
}
