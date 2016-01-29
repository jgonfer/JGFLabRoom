//
//  Constants.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 14/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit


// MARK: API Key & Secret
// This information shouldn't be stored in the app.

let kApiTwitterConsumerKey = "OYPHJXmYb1Cxy17dzBT4Ka7XB"
let kApiTwitterConsumerecret = "DW02qNxB9NbI7enPdng7JmSS1krOLmbnWwVPEuo92eI6PX3F0Z"
let kApiTwitterAccessToken = "299522050-hb4KjuNZB8cdsYSE7siYaVUi3DKydT91uMLeWq3X"
let kApiTwitterAccessTokenSecret = "U5fqldL0ZiNzpjymUWxzguEdCobOGuiOhQSCSh7TxK9Aq"

let kApiGoogleDriveConsumerKey = "643943608923-8g6rebcsiakcvc0qsk564bisk0p5ibqs.apps.googleusercontent.com"
let kApiGoogleDriveConsumerSecret = "ghNixvFtLYwaRtWvlv8Mbzkh"

let kApiGitHubClientId = "5072d51c60d715e79c95"
let kApiGitHubClientSecret = "28af606db9df21a2ac4c4eb72ddd00306790fc00"


// MARK: Keychain Keys

let kKeychainKeyGitHub = "github"

// MARK: Apps URLs

let kUrlApps = "https://itunes.apple.com/search?term=josep+gonzalez+fernandez&country=us&entity=software"
let kUrlTravelApps = "https://itunes.apple.com/search?term=travel&country=us&entity=software&limit=200"
let kUrlGameApps = "https://itunes.apple.com/search?term=games&country=us&entity=software&limit=200"
let kUrlProductivityApps = "https://itunes.apple.com/search?term=productivity&country=us&entity=software&limit=200"

// MARK: GitHub URLs

let kUrlGitHubRepos = "https://api.github.com/user/repos"
let kUrlGitHubAuth = "https://github.com/login/oauth/authorize?client_id=\(kApiGitHubClientId)&scope=repo&state=Request_Access_Token"
let kUrlGitHubGetToken = "https://github.com/login/oauth/access_token"


// MARK: Segues Identifier

let kSegueIdEventKit = "showEventKit"
let kSegueIdListEvents = "showListEvents"
let kSegueIdGCD = "showGCD"
let kSegueIdListApps = "showListApps"
let kSegueIdCommonCrypto = "showCommonCrypto"
let kSegueIdKeychain = "showKeychain"
let kSegueIdTouchID = "showTouchID"
let kSegueIdCCSettings = "showCCSettings"
let kSegueIdSocial = "showSocial"
let kSegueIdSocialOptions = "showSocialOptions"
let kSegueIdSTwitter = "showSTwitter"
let kSegueIdSGoogleDrive = "showSGoogleDrive"
let kSegueIdSGitHub = "showSGitHub"


// MARK: Error Domains

let kErrorDomainConnection = "Connection Error"
let kErrorDomainGitHub = "GitHub Error"


// MARK: Error Codes

let kErrorCodeJSONSerialization = 1
let kErrorCodeGitHubNoToken = 2
let kErrorCodeGitHubBadCredentials = 3

// MARK: Error Messages

let kErrorMessageJSONSerialize = "Could not serialize JSON object"
let kErrorMessageRetryRequest = "Please retry your request"
let kErrorMessageNoToken = "There is no token available"
let kErrorMessageLogInAgain = "Please log in again"
let kErrorMessageGitHubBadCredentials = "Bad credentials"


// MARK: Colors

// Green Mantis
let kColorPrimary = UIColor(red:0.39, green:0.8, blue:0.35, alpha:1)
let kColorPrimaryAlpha = UIColor(red:0.39, green:0.8, blue:0.35, alpha:0.3)
let kColorWrong = UIColor(red:0.82, green:0.26, blue:0.14, alpha:1)