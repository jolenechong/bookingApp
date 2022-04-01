//
//  UpdateBookingViewController.swift
//  BookingApp
//
//  Created by Swift on 28/3/22.
//

import UIKit
import FirebaseFirestore

class UpdateBookingViewController: UIViewController {
        
    var db = Firestore.firestore()
    var booking:Booking?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var availabilityView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // limit date input again
        if let b = booking {
            datePicker.minimumDate = Date()
            datePicker.maximumDate = Calendar.current.date(byAdding: .weekday, value: 7, to: b.current_date)
        }

    }
    
    @IBAction func datePickerPressed(_ sender: Any) {
        DataManager.loadAvailability(original_date: datePicker.date){
        action in
        
        if action != 0{
            let percentageFilled = (Double(action)/Double(Constants.Storyboard.totalEmployees)) * Double(100)
            let rounded = percentageFilled.rounded()
            if rounded > 50{
                self.availabilityView.text = "Availability: Not Available"
                self.availabilityView.textColor = UIColor.systemRed
            }
        }
    }
    }
    
    @IBAction func updateBookingPressed(_ sender: Any) {
        // update booking with id
        
        if availabilityView.text != "Availability: Not Available"{
            if let b = booking {
                
                if b.date != datePicker.date {
                    // if date changed, update booking
                    updateBooking(id: b.id, initialDate: b.date)
                }
                else
                {
                    print("same date")
                }
                self.transitionToHome()
            }
        }else{
            let alert = UIAlertController(
                title: "Please select an available date",
                message: "",
                preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
    }
    
    func updateBooking(id:String, initialDate: Date) {
        let ref = db.collection("bookings").document(id)

        // update date
        ref.updateData([
            "date": datePicker.date
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        incrementAvailability(datePicker: datePicker)
        decrementAvailability(date: initialDate)
        
    }
    
    func transitionToHome() {
        // go back to home using the tab bar controller
        let tabBarViewController = UIStoryboard(name: Constants.Storyboard.mainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as! UITabBarController

          view.window?.rootViewController = tabBarViewController
          view.window?.makeKeyAndVisible()

    }

}
