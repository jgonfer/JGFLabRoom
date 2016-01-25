//
//  SNetworks.swift
//  JGFLabRoom
//
//  Created by Josep González on 25/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

enum SNetworks {
    case Twitter, Facebook, GoogleDrive, Pinterest, Instagram, Vine, LinkedIn, GitHub
    static let types: [SNetworks] = [.Twitter, .Facebook, .GoogleDrive, .Pinterest, .Instagram, .Vine, .LinkedIn, .GitHub]
    static let titles: [String] = ["Twitter", "Facebook", "Google Drive", "Pinterest", "Instagram", "Vine", "LinkedIn", "GitHub"]
    static let segues: [String?] = [nil, nil, nil, nil, nil, nil, nil, kSegueIdSGitHub]
    
    static func getTitle(type: SNetworks) -> String {
        return SNetworks.titles[type.hashValue]
    }
    
    static func getOptionsArray(networkType: SNetworks) -> [String] {
        switch networkType {
        case .Twitter:
            return ["Sign in with Twitter"]
        case .Facebook:
            return ["Sign in with Facebook"]
        case .GoogleDrive:
            return ["Sign in with Google Drive"]
        case .Pinterest:
            return ["Sign in with Pinterest"]
        case .Instagram:
            return ["Sign in with Instagram"]
        case .Vine:
            return ["Sign in with Vine"]
        case .LinkedIn:
            return ["Sign in with LinkedIn"]
        case .GitHub:
            return ["Sign in with GitHub",
                "View repositories"]
        }
    }
}