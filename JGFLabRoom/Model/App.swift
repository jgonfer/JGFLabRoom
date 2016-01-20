//
//  App.swift
//  JGFLabRoom
//
//  Created by Josep González on 20/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

struct App {
    var title: String
    var url: String
    var logo: String
    
    init(title: String, url: String, logo: String) {
        self.title = title
        self.url = url
        self.logo = logo
    }
}