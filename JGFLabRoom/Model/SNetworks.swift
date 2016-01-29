//
//  SNetworks.swift
//  JGFLabRoom
//
//  Created by Josep González on 25/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

enum SNetworks {
    case Twitter, Facebook, GoogleDrive, Pinterest, Instagram, Vine, Spotify, LinkedIn, GitHub
    static let types: [SNetworks] = [.Twitter, .Facebook, .GoogleDrive, .Pinterest, .Instagram, .Vine, .Spotify, .LinkedIn, .GitHub]
    static let titles: [String] = ["Twitter", "Facebook", "Google Drive", "Pinterest", "Instagram", "Vine", "Spotify", "LinkedIn", "GitHub"]
    static let segues: [String?] = [nil, kSegueIdSFacebook, nil, nil, nil, nil, nil, nil, kSegueIdSGitHub]
    
    static func getTitle(type: SNetworks) -> String {
        return SNetworks.titles[type.hashValue]
    }
    
    static func getOptionsArray(networkType: SNetworks) -> [String] {
        switch networkType {
        case .Twitter:
            return ["Sign in"]
        case .Facebook:
            return ["Sign in"]
        case .GoogleDrive:
            return ["Sign in"]
        case .Pinterest:
            return ["Sign in"]
        case .Instagram:
            return ["Sign in"]
        case .Vine:
            return ["Sign in"]
        case .Spotify:
            return ["Sign in"]
        case .LinkedIn:
            return ["Sign in"]
        case .GitHub:
            return ["Sign in",
                "View repositories"]
        }
    }
}