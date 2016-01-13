//
//  TypeListEvents.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

enum TypeListEvents {
    case Calendar, Year, Month, Day
    static let types: [TypeListEvents] = [.Calendar, .Year, .Month, .Day]
    static let titles: [String] = ["Calendar", "Year", "Month", "Day"]
    
    func getImage(type: TypeListEvents) -> UIImage {
        return UIImage(named: TypeListEvents.titles[type.hashValue])!
    }
}
