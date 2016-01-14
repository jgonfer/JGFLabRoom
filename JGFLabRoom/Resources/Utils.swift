//
//  Utils.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 14/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

class Utils {
    
    // DATES Management
    class func getStartEndDateForYear(year: Int) -> (NSDate, NSDate)? {
        let startDateString = "\(year)-01-01"
        let endDateString = "\(year)-12-31"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let startDate = dateFormatter.dateFromString(startDateString) else {
            return nil
        }
        guard let endDate = dateFormatter.dateFromString(endDateString) else {
            return nil
        }
        return (startDate, endDate)
    }
}