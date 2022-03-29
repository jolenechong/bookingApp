//
//  BookingTableViewCell.swift
//  BookingApp
//
//  Created by Swift on 23/3/22.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
