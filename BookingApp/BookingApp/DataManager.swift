//
//  DataManager.swift
//  BookingApp
//
//  Created by Swift on 23/3/22.
//

import UIKit
import FirebaseFirestore

class DataManager: NSObject {
    static var db = Firestore.firestore()

        static func deleteBooking(id: String) {
            db.collection("bookings").document(id).delete() { err in
                if let err = err {
                    print("Error removing document \(id): \(err)")
                } else {
                    print("Document \(id) successfully removed!")
                }
            }
        }
    
    // loads list of bookings according to the current user
    static func loadBookings(email: String, onComplete: @escaping (([Booking]) -> Void)) {
        db.collection("bookings")
            .whereField("email", isEqualTo: email)
            .whereField("date", isGreaterThanOrEqualTo: Date())
            .getDocuments(){(querySnapshot, err) in
                
            if let err = err {
                print("Error getting documents: \(err)")
                onComplete([])
            } else {
                var bookingsList: [Booking] = []
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    //clean values
                    let stamp1 = data["current_date"] as? Timestamp
                    let stamp2 = data["date"] as? Timestamp
                    if stamp1 != nil && stamp2 != nil{
                        let current_date_cleaned = stamp1!.dateValue()
                        let date_cleaned = stamp2!.dateValue()
                        
                        let bookingsData = Booking(
                            id: document.documentID,
                            curr_date: current_date_cleaned,
                            date: date_cleaned,
                            ARTResult: data["ARTResult"] as! Bool,
                            image: data["image"] as! String,
                            email: data["email"] as! String
                        )
                        bookingsList.append(bookingsData)
                    }
                    
                }
                onComplete(bookingsList)
            }
        }
    }
    
    static func loadAvailability(original_date: Date, onComplete: @escaping ((Int) -> Void)) {
        
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: original_date)) else {
            fatalError("Failed to strip time from Date object")
        }

        db.collection("availability").whereField("date", isEqualTo: date).getDocuments() {
                        
            (querySnapshot, err) in
            
            if querySnapshot?.isEmpty == true{
                onComplete(0)
            }else{
                if let err = err {
                    print("Error getting documents: \(err)")
                    onComplete(0)
                } else {
                    let data = querySnapshot!.documents[0].data()
                    onComplete(data["booked"]! as! Int)
                }
            }
        }
    }
    
    static func getUser(email: String, onComplete: @escaping (([User]) -> Void))  {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments() {
                        
            (querySnapshot, err) in
            
            if querySnapshot?.isEmpty == true{
                onComplete([])
            }else{
                if let err = err {
                    print("Error getting documents: \(err)")
                    onComplete([])
                } else {
                    let data = querySnapshot!.documents[0].data()
                    
                    let userData = User(
                        name: data["name"] as! String,
                        email: data["email"] as! String
                    )
                    
                    onComplete([userData])
                }
            }
        }
    }

    
}
