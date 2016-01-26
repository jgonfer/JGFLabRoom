//
//  Repos.swift
//  JGFLabRoom
//
//  Created by Josep González on 25/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

class Repo {
    var id: String?
    var name: String?
    var description: String?
    var ownerLogin: String?
    var url: String?
    
    required init(id: String, name: String, description: String, ownerLogin: String, url: String) {
        self.id = id
        self.name = name
        self.description = description
        self.ownerLogin = ownerLogin
        self.url = url
    }
}