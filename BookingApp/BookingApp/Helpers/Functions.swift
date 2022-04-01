//
//  Functions.swift
//  BookingApp
//
//  Created by Swift on 24/3/22.
//

import Foundation
import UIKit
import FirebaseFirestore

let db = Firestore.firestore()

// helper functions
func firstDayOfWeek() -> Date {
    var c = Calendar(identifier: .iso8601)
    c.timeZone = TimeZone(secondsFromGMT: 0)!
    return c.date(from: c.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date()))!
}

func lastDayOfWeek() -> Date {
    var c = Calendar(identifier: .iso8601)
    c.timeZone = TimeZone(secondsFromGMT: 0)!
    let firstDay = c.date(from: c.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date()))!
    let lastDay = Calendar.current.date(byAdding: .day, value: 6, to: firstDay)!
    
    return lastDay
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

func incrementAvailability( datePicker: UIDatePicker) {
    let availability = db.collection("availability")
    let time = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: datePicker.date)!

    availability
        .whereField("date",isEqualTo: time)
        .limit(to: 1).getDocuments(completion: { querySnapshot, error in
            
        if let err = error {
            print(err.localizedDescription)
            return
        }
            
            let document = querySnapshot!.documents.first
            
            if document != nil{
                // increment booked slots
                let booked = document!.get("booked")
                document?.reference.updateData(["booked": booked as! Int+1])
            }else{
                // if date not alr in db den add it and add 1
                var ref: DocumentReference? = nil
                ref = availability.addDocument(data: [
                    "booked": 1,
                    "date": time
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            }
    })
}

func decrementAvailability( date: Date) {
    let availability = db.collection("availability")
    let time = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!

    availability
        .whereField("date",isEqualTo: time)
        .limit(to: 1).getDocuments(completion: { querySnapshot, error in
            
        if let err = error {
            print(err.localizedDescription)
            return
        }
            
            let document = querySnapshot!.documents.first
            
            if document != nil{
                // decrement booked slots
                let booked = document!.get("booked")
                document?.reference.updateData(["booked": booked as! Int-1])
            }else{
                print("Date not found, cannot decrement a date that does not exist")
                return
            }
    })
}
