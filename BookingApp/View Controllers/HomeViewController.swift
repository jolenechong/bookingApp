//
//  HomeViewController.swift
//  BookingApp
//
//  Created by Swift on 21/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bookingList : [Booking] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var WelcomeMsgView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : BookingTableViewCell = tableView.dequeueReusableCell (withIdentifier: "BookingCell", for: indexPath) as! BookingTableViewCell
        let m = bookingList[indexPath.row]
        
        // initialise date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d MMM yyyy"
        let nowDate = dateFormatter.string(from: Date())
        
        //date to string to display date where the booking was placed
        let showCurrDate = dateFormatter.string(from: m.current_date)
        cell.currentDateLabel.text =  "Booked on \(showCurrDate)"
        
        //date to string to display date
        var showDate = dateFormatter.string(from: m.date)
        cell.dateLabel.text = showDate
        
        // show date in relation to current day
        // get monday and sunday of this week
        let mondayInWeek = firstDayOfWeek()
        let sundayInWeek = lastDayOfWeek()

        Utilities.styleTagLabel(cell.todayLabel)
        // if date booked for is after this weeks monday, means its next week
        if showDate == nowDate{
            cell.todayLabel.text = "  Today  "
        }else if mondayInWeek > m.date{
            // if this monday is after date of booking
            dateFormatter.dateFormat = "EEEE"
            showDate = dateFormatter.string(from: m.date)

            cell.todayLabel.text = "  Next \(showDate)  "
        }else{
            // if this monday is before date of booking
            dateFormatter.dateFormat = "EEEE"
            showDate = dateFormatter.string(from: m.date)
            
            if sundayInWeek < m.date{
                // if this sunday is before date of booking
                cell.todayLabel.text = "  Next \(showDate)  "
            }else{
                cell.todayLabel.text = "  This \(showDate)  "
            }
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let user_name = "Jolene" // need to get user data from firebase
//        WelcomeMsgView.text = "Welcome, \(user_name)"
        tableView?.dataSource = self

    }
    
//    func getName(){
//        // Create a query against the collection.
//        let userEmail = Auth.auth().currentUser!.email
//
//        db.collection("users").whereField("email", isEqualTo: "jolene@gmail.com")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    //get first entry
//                    print(querySnapshot!.documents[0].data())
//                    self.user_name = querySnapshot!.documents[0].data()["name"] as! String
//                }
//            }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load bookingd according to the user, only the users bookings
        if let userEmail = Auth.auth().currentUser!.email{
            loadBookings(userEmail: userEmail)
        }
    }
    
    func loadBookings(userEmail: String) {
        // need to pass in real value for userid
        DataManager.loadBookings(email: userEmail)
        {
            userListFromFirebase in

            self.bookingList = userListFromFirebase
            self.tableView?.reloadData()
        }
    }
    
    // delete by swiping TODO: DOESNT WORK RN
    func tableView(_ tableView: UITableView, commit editingStyle:
                   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // confirmation message
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete your booking?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {action in
                // delete booking acording to its id
                let booking = self.bookingList[indexPath.row]
                DataManager.deleteBooking(id: booking.id)
                if let userEmail = Auth.auth().currentUser!.email{
                    self.loadBookings(userEmail: userEmail)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {action in
                // back to home, dont delete anything
                self.transitionToHome()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func transitionToHome() {
        // go back to home using the tab bar controller
        let tabBarViewController = UIStoryboard(name: Constants.Storyboard.mainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as! UITabBarController

          view.window?.rootViewController = tabBarViewController
          view.window?.makeKeyAndVisible()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Hide Tab Bar when push
        segue.destination.hidesBottomBarWhenPushed = true
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showBookingDetails"){
            let detailsViewController = segue.destination as!
            BookingDetailsViewController
            if let path = tableView.indexPathForSelectedRow {
                let booking = bookingList[path.row]
                detailsViewController.booking = booking
            }
        }
        
//        // Here we check for the AddMovie segue,
//        // which is trigger by the user clicking on the +
//        // button at the top of the navigation bar
//        //
//        if(segue.identifier == "AddMovie"){
//            let saveMovieViewController = segue.destination as!
//            SaveMovieViewController
//            let movie = Movie(id: "", name: "", desc: "", rating: 0, image:
//                                "https://raw.githubusercontent.com/lihaiyun/ios/main/resources/popcorn.png")
//            saveMovieViewController.movie = movie
//
//        }
        
    }
}
