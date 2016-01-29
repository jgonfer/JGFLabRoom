//
//  GitHubAPIManager.swift
//  JGFLabRoom
//
//  Created by Josep González on 26/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit
import Foundation

class GitHubAPIManager {
    static let sharedInstance = GitHubAPIManager ()
    
    var OAuthTokenCompletionHandler:(NSError? -> Void)?
    var OAuthToken: String? {
        set {
            if let valueToSave = newValue {
                KeychainWrapper.setString(valueToSave, forKey: kKeychainKeyGitHub)
            }
            else { // Is set to nil, so we delete the existing value for the GitHub key
                KeychainWrapper.removeObjectForKey(kKeychainKeyGitHub)
            }
        }
        get {
            // Try to load from keychain
            let value = KeychainWrapper.stringForKey(kKeychainKeyGitHub)
            if let token =  value {
                return token
            }
            return nil
        }
    }
    
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    // MARK: - OAuth flow
    
    func startOAuth2Login() {
        if let authURL:NSURL = NSURL(string: kUrlGitHubAuth) {
            UIApplication.sharedApplication().openURL(authURL)
        }
        // TODO: call completionHandler after getting token or error
    }
    
    func processOAuthStep1Response(url: NSURL) {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        var code: String?
        var state: String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if (queryItem.name.lowercaseString == "code") {
                    code = queryItem.value
                }
                if (queryItem.name.lowercaseString == "state") {
                    state = queryItem.value
                }
                if let _ = code, _ = state {
                    break
                }
            }
        }
        print(url)
        print(code)
        print(state)
        
        guard let codeUnwrapped = code else {
            return
        }
        
        let tokenParams: [String: AnyObject] = ["client_id": kApiGitHubClientId, "client_secret": kApiGitHubClientSecret, "code": codeUnwrapped]
        print(tokenParams)
        
        ConnectionHelper.sharedInstance.startConnection(kUrlGitHubGetToken, method: .POST, params: tokenParams, delegate: self)        
    }
    
    private func tokenRefreshed() {
        if self.hasOAuthToken() {
            if let completionHandler = self.OAuthTokenCompletionHandler {
                completionHandler(nil)
            }
        } else {
            if let completionHandler = self.OAuthTokenCompletionHandler {
                let cError = NSError(domain: kErrorDomainGitHub, code: kErrorCodeGitHubNoToken, userInfo: [NSLocalizedDescriptionKey: kErrorMessageNoToken, NSLocalizedRecoverySuggestionErrorKey: kErrorMessageRetryRequest])
                completionHandler(cError)
            }
        }
    }
}

extension GitHubAPIManager: ConnectionHelperDelegate {
    func connectionGetTokenFinished(accessToken: String?) {
        OAuthToken = accessToken
        tokenRefreshed()
    }
}