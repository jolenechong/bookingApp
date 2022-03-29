//
//  AddBookingViewController.swift
//  BookingApp
//
//  Created by Swift on 24/3/22.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class AddBookingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var db = Firestore.firestore()
    var booking: Booking?
    private let storage = Storage.storage().reference()
        
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var availabilityView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        DataManager.addMovie()
        
        labelView.textColor = UIColor(hue: 357/360, saturation: 81/100, brightness: 94/100, alpha: 1.0)
        labelView.text = "Please Upload an Image"
        
        // set minimum and maximum date, only can book in advance of 7 days
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .weekday, value: 7, to: Date())
        
    }
    
    @IBOutlet weak var positiveRadioButton: RadioButton!
    @IBOutlet weak var negativeRadioButton: RadioButton!
    
    @IBAction func positiveSelected(_ sender: Any) {
        // only can select one button at a time
        negativeRadioButton.isSelected = false
    }
    @IBAction func negativeSelected(_ sender: Any) {
        // only can select one button at a time
        positiveRadioButton.isSelected = false
    }
    
    @IBAction func datePickerUpdated(_ sender: Any) {
        DataManager.loadAvailability(original_date: datePicker.date){
            action in
            
            if action != 0{
                let percentageFilled = (Double(action)/Double(Constants.Storyboard.totalEmployees)) * Double(100)
                let rounded = percentageFilled.rounded()
                if rounded > 50{
                    self.availabilityView.text = "Availability: Not Available"
                    self.availabilityView.textColor = UIColor.systemRed
                }else{
                    // doesnt go back to this for some reason
                    self.availabilityView.text = "Availability: Available"
                    self.availabilityView.textColor = UIColor.systemGreen
                }
            }else{
                self.availabilityView.text = "Availability: Available"
                self.availabilityView.textColor = UIColor.systemGreen
                // TODO: need to do the same for update
            }
            
        }
    }
    
    
    @IBAction func uploadImageTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController( _ picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        
        // upload image data
        // get download url
        // save download data to firestore
        
        // generate random string and user uid to use as file storage name
        let userUID = Auth.auth().currentUser!.uid
        let randString = randomString(length: 8)
        let storageLocation =  "images/\(userUID)-\(randString).png"
                
        storage.child(storageLocation).putData(imageData, metadata:nil, completion: {_, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            
            self.storage.child(storageLocation).downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
            
            
        })
        
        labelView.text = "Sucessfuly Uploaded!"
        labelView.textColor = UIColor.systemGreen
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func handleSubmit(_ sender: Any) {
        
        // ensure all not empty and ART is negative
        if negativeRadioButton.isSelected == false || labelView.text == "Please Upload an Image" || availabilityView.text == "Availability: Not Available"
        {
            let alert = UIAlertController(
                title: "Please enter all fields and select available date",
                message: "",
                preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        addBooking()
        self.transitionToHome()
    }
    
    func addBooking() {
        // get URL string
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String, let url = URL(string: urlString) else{
                    return
                }
        
        // add into db
        var ref: DocumentReference? = nil
        ref = db.collection("bookings").addDocument(data: [
            "current_date": Date(),
            "date": datePicker.date,
            "ARTResult": false,
            "image": urlString,
            "email": Auth.auth().currentUser!.email!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        incrementAvailability()
//        let updateRef = db.collection("availability").whereField("date", isEqualTo:datePicker.date)
//
//
//
//        // Set the "capital" field of the city 'DC'
//        updateRef.updateData([
//            "booked": FieldValue.increment(Int64(1))
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
        
        // update availability
        
    }
    
    func transitionToHome() {
        // go back to home using the tab bar controller
        let tabBarViewController = UIStoryboard(name: Constants.Storyboard.mainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as! UITabBarController

          view.window?.rootViewController = tabBarViewController
          view.window?.makeKeyAndVisible()

    }
    
    func incrementAvailability() {
        // TODO: NOT WORKING
        let availability = self.db.collection("availability")
        availability.whereField("date", isEqualTo: datePicker.date).limit(to: 1).getDocuments(completion: { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }

            guard let docs = querySnapshot?.documents else { return }

            for doc in docs {
                let docId = doc.documentID
                let booked = doc.get("booked")
                
                let ref = doc.reference
                ref.updateData(["age": booked as! Int+1])
            }
        })
        
        // what about when the date not yet in db?? TODO: HERE
    }
}
