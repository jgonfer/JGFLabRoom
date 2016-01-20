//
//  Utils.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 14/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit
import Foundation

class Utils {
    
    // MARK: GENERAL
    
    static var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    static var GlobalUserInteractiveQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    }
    static var GlobalUserInitiatedQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }
    static var GlobalUtilityQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    }
    static var GlobalBackgroundQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }
    
    
    // MARK: TABLEVIEW Management
    
    class func registerStandardXibForTableView(tableView: UITableView, name: String) {
        // Registration of a standard UITableViewCell with identifier @name. It'll have standard parameters like cell.textLabel, cell.detailTextLabel and cell.imageView
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: name)
    }
    
    class func registerCustomXibForTableView(tableView: UITableView, name: String) {
        // Registration of a new Nib with identifier @name
        tableView.registerNib(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    // MARK: NAVIGATION BAR Management
    
    class func cleanBackButtonTitle(nav: UINavigationController?) {
        // Replacement of the existing button in the navigationBar
        nav?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
    }
    
    
    // MARK: DATES Management
    
    class func getStartEndDateForYear(year: Int) -> (NSDate, NSDate)? {
        // We get the @year period by setting the start date of the @year, and the end date of the @year
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
        // Request for the three first characters of the weekday (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEE"
        
        return dayTimePeriodFormatter.stringFromDate(date).uppercaseString
    }
    
    class func getWeekdayNameFromDate(date: NSDate) -> String {
        // Request for the full name of the weekday (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE"
        
        return dayTimePeriodFormatter.stringFromDate(date).capitalizedString
    }
    
    class func getMonthThreeCharsFromDate(date: NSDate) -> String {
        // Request for the three first characters of the month (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM"
        
        return dayTimePeriodFormatter.stringFromDate(date).uppercaseString
    }
    
    class func getMonthNameFromDate(date: NSDate) -> String {
        // Request for the full name of the month (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM"
        
        return dayTimePeriodFormatter.stringFromDate(date).capitalizedString
    }
    
    class func getMonthsArraysForEvents(events: [[String:String]]?) -> (months: [String]?, eventsSorted: [[[String:String]]]?) {
        // Check that we have events to iterate
        guard let events = events else {
            return (nil, nil)
        }
        var months: [String]?
        var eventsSorted: [[[String:String]]]?
        for event in events {
            // Check that the event has a date to use
            guard let dateString = event["date"] else {
                continue
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            // @col is a counter to control the months that we add to our @eventStore array
            var col = 0
            // Check that there is a valid date
            if let date = dateFormatter.dateFromString(dateString) {
                let month = getMonthNameFromDate(date)
                // Check if the @months array is initialized
                guard let _ = months else {
                    // If isn't initialized, we initialize the array with the first month and @eventStore with the @event that we have
                    months = [month]
                    eventsSorted = [[event]]
                    // Let's keep going on next iteration
                    continue
                }
                // Check if @months array contains the month of the current @event
                guard months!.contains(month) else {
                    // If it isn't contained, we increment @col
                    col++
                    // We also add the current @month (Month's name) to @months
                    months?.append(month)
                    // And finally we add a new array initialized with the current @event to @eventSorted. 
                    eventsSorted?.append([event])
                    // Our intention is to represent the new position @col of the array like a new month store in the array @eventStored. This kind of order will help us in the future when we'll display the array in our tableView providing this array as the data source.
                    
                    // Let's keep going on next iteration
                    continue
                }
                eventsSorted![col].append(event)
            }
        }
        return (months, eventsSorted)
    }
}