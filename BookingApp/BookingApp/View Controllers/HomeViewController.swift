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
    @IBOutlet weak var imageButton1: UIImageView!
    @IBOutlet weak var imageButton2: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailView: UILabel!
    
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
        
        // display user info
        let user_email = Auth.auth().currentUser!.email
        emailView.text = user_email
        if user_email != nil{
            DataManager.getUser(email:user_email!)
            {
                userInfo in

                let user_name = userInfo[0]
                self.WelcomeMsgView.text = "Welcome, \(user_name.name)"
            }
        }
        
        // load table view's datasource
        tableView?.dataSource = self
        
        // make image clickable for "Calendar"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTappedCalendar(gesture:)))
        imageButton1.addGestureRecognizer(tapGesture)
        imageButton1.isUserInteractionEnabled = true
        
        // make image clickable for "Add bookings"
        let tapGestureBookings = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTappedBooking(gesture:)))
        imageButton2.addGestureRecognizer(tapGestureBookings)
        imageButton2.isUserInteractionEnabled = true
    }
    
    @objc func imageTappedCalendar(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            tabBarController?.selectedIndex = 2

        }
    }
    @objc func imageTappedBooking(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            tabBarController?.selectedIndex = 1

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load bookings according to the user, only the users bookings
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
        
    }
}
