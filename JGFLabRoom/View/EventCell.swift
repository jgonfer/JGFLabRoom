//
//  EventCell.swift
//  JGFLabRoom
//
//  Created by Josep González on 18/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    func setupCell(title: String?, date: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let componenets = calendar.components([.Month, .Day], fromDate: date)
        
        dayLabel.text = "\(componenets.day)"
        weekdayLabel.text = Utils.getWeekdayThreeCharsFromDate(date)
        if let title = title {
            eventTitleLabel.text = title
        } else {
            eventTitleLabel.text = ""
        }
    }
}
