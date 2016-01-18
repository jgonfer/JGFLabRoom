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
    
    class func getWeekdayThreeCharsFromDate(date: NSDate) -> String {
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEE"
        
        return dayTimePeriodFormatter.stringFromDate(date).uppercaseString
    }
    
    class func getWeekdayNameFromDate(date: NSDate) -> String {
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE"
        
        return dayTimePeriodFormatter.stringFromDate(date).capitalizedString
    }
    
    class func getMonthThreeCharsFromDate(date: NSDate) -> String {
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM"
        
        return dayTimePeriodFormatter.stringFromDate(date).uppercaseString
    }
    
    class func getMonthNameFromDate(date: NSDate) -> String {
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM"
        
        return dayTimePeriodFormatter.stringFromDate(date).capitalizedString
    }
    
    class func getMonthsArraysForEvents(events: [[String:String]]?) -> (months: [String]?, eventsSorted: [[[String:String]]]?) {
        guard let events = events else {
            return (nil, nil)
        }
        var months: [String]?
        var eventsSorted: [[[String:String]]]?
        for event in events {
            guard let dateString = event["date"] else {
                continue
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            var col = 0
            if let date = dateFormatter.dateFromString(dateString) {
                let month = getMonthNameFromDate(date)
                guard let _ = months else {
                    months = [month]
                    eventsSorted = [[event]]
                    continue
                }
                guard months!.contains(month) else {
                    col++
                    months?.append(month)
                    eventsSorted?.append([event])
                    continue
                }
                eventsSorted![col].append(event)
            }
        }
        return (months, eventsSorted)
    }
}