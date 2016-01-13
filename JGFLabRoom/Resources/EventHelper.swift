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
    
    var delegate: EventHelperDelegate!
    
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
        case .Denied:
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
        return eventStore.calendarsForEntityType(EKEntityType.Event)
    }
    
    func getCalendarNamesFromUser() -> [String]? {
        let calendars = getCalendarsFromUser()
        var names: [String]?
        for calendar: EKCalendar in calendars {
            guard let _ = names else {
                names = [calendar.title]
                continue
            }
            names?.append(calendar.title)
        }
        return names
    }
}