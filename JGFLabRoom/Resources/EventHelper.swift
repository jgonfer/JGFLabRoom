//
//  EventHelper.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI

protocol EventHelperDelegate: class {
    
}

let singletonEH = EventHelper()

class EventHelper {
    let eventStore = EKEventStore()
    
    var delegate: EventHelperDelegate?
    
    init() {
        
    }
    
    class var sharedInstance: EventHelper {
        return singletonEH
    }
    
    func requestCalendarPermissions(completion: ((granted: Bool) -> Void)? = nil) {
        switch EKEventStore.authorizationStatusForEntityType(.Event) {
        case .Authorized:
            dispatch_async(dispatch_get_main_queue(), {
                completion?(granted: true)
            })
        case .Restricted, .Denied:
            dispatch_async(dispatch_get_main_queue(), {
                completion?(granted: false)
            })
        case .NotDetermined:
            // 3
            EKEventStore().requestAccessToEntityType(.Event, completion:
                {[weak self] (granted: Bool, error: NSError?) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        completion?(granted: granted)
                    })
                })
        default:
            print("Case Default")
        }
    }
    
    func getCalendarsFromUser() -> [EKCalendar] {
        return eventStore.calendarsForEntityType(.Event)
    }
    
    func getCalendarNamesFromUser() -> [[String:String]]? {
        let calendars = getCalendarsFromUser()
        var names: [[String:String]]?
        for calendar: EKCalendar in calendars {
            guard let _ = names else {
                names = [["identifier": calendar.calendarIdentifier, "title": calendar.title]]
                continue
            }
            
            names?.append(["identifier": calendar.calendarIdentifier, "title": calendar.title])
        }
        return names
    }
    
    func getCalendar(identifier: String) -> EKCalendar? {
        let calendars = getCalendarsFromUser()
        for calendar: EKCalendar in calendars {
            if calendar.calendarIdentifier == identifier {
                return calendar
            }
        }
        return nil
    }
    
    func getEventYearsFromUser(identifier: String, completion: (years: [[String:String]]?) -> ()) {
        var years: [[String:String]]?
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            let calendar = self.getCalendar(identifier)//eventStore.calendarWithIdentifier(identifier)
            if let calendar = calendar {
                for year: Int in 1970...2050 {
                    if let dates = Utils.getStartEndDateForYear(year) {
                        let predicate = self.eventStore.predicateForEventsWithStartDate(dates.0, endDate: dates.1, calendars: [calendar])
                        let events = self.eventStore.eventsMatchingPredicate(predicate).sort {
                            $0.startDate.compare($1.startDate) == NSComparisonResult.OrderedAscending
                        }
                        guard events.count > 0 else {
                            continue
                        }
                        guard let _ = years else {
                            years = [["identifier": identifier, "title": "\(year)", "events": "\(events.count)"]]
                            continue
                        }
                        years?.append(["identifier": "\(identifier)", "title": "\(year)", "events": "\(events.count)"])
                    }
                    // As soon as we've readed the @year, we display it
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        completion(years: years)
                    }
                }
            }
            // If we'd like to display all the @years at once, we should do it at this point by calling the dispatch_async function
        }
    }
    
    func getEventsFromUser(identifier: String, year: Int, completion: (events: [[String:String]]?) -> ()) {
        var events: [[String:String]]?
        let calendar = getCalendar(identifier)//eventStore.calendarWithIdentifier(identifier)
        if let calendar = calendar {
            if let dates = Utils.getStartEndDateForYear(year) {
                let predicate = self.eventStore.predicateForEventsWithStartDate(dates.0, endDate: dates.1, calendars: [calendar])
                let eventsResult = self.eventStore.eventsMatchingPredicate(predicate).sort {
                    $0.startDate.compare($1.startDate) == NSComparisonResult.OrderedAscending
                }
                for event: EKEvent in eventsResult {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let dateString = dateFormatter.stringFromDate(event.startDate)
                    guard let _ = events else {
                        events = [["identifier": event.eventIdentifier, "title": event.title, "date": dateString]]
                        continue
                    }
                    events?.append(["identifier": event.eventIdentifier, "title": event.title, "date": dateString])
                }
            }
        }
        completion(events: events)
    }
}