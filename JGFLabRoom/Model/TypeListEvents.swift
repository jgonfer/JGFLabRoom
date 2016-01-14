//
//  TypeListEvents.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

enum TypeListEvents {
    case Calendar, Year, Month, Day, Event
    static let types: [TypeListEvents] = [.Calendar, .Year, .Month, .Day, .Event]
    static let titles: [String] = ["Calendars", "Years", "Months", "Days", "Events"]
    
    static func getTitles(type: TypeListEvents) -> String {
        return TypeListEvents.titles[type.hashValue]
    }
}
