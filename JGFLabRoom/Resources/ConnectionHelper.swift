//
//  ConnectionHelper.swift
//  JGFLabRoom
//
//  Created by Josep González on 20/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

protocol ConnectionHelperDelegate {
    func connectionAppsInProgress()
    func connectionAppsFinished(apps: [App]?)
    
    func connectionGetTokenFinished(accessToken: String?)
    func connectionReposFinished(repos: [Repo]?, error: NSError?)
}

extension ConnectionHelperDelegate {
    func connectionAppsInProgress() {}
    func connectionAppsFinished(apps: [App]?) {}
    
    func connectionGetTokenFinished(accessToken: String?) {}
    func connectionReposFinished(repos: [Repo]?, error: NSError?) {}
}

class ConnectionHelper: NSObject, NSURLConnectionDelegate {
    enum Method: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    var connectionCompletionHandler: ((NSData?, NSError?) -> Void)?
    var delegate: ConnectionHelperDelegate?
    var connection: NSURLConnection?
    
    static let sharedInstance = ConnectionHelper()
    
    var data = NSMutableData()
    
    
    // MARK: Help Methods
    
    func dataFromDict<ValueType>(dict: [String:ValueType]) -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(dict as! AnyObject)
    }
    
    
    // MARK: Connection Method
    
    func startConnection(url: String, method: Method, params: [String:AnyObject]?, delegate: ConnectionHelperDelegate?){
        self.data = NSMutableData()
        self.delegate = delegate
        do {
            let urlPath: NSURL = NSURL(string: url)!
            let request = NSMutableURLRequest(URL: urlPath)
            request.HTTPMethod = method.rawValue
            
            // Check if we need to pass parameters in our call
            if let params =  params {
                if NSJSONSerialization.isValidJSONObject(params) {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            // Check what kind of call is due to know if this is a call that requires an Authorization header with a token or whatever
            switch url {
            case kUrlGitHubRepos:
                if let token = GitHubAPIManager.sharedInstance.OAuthToken {
                    request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
                    request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
                }
            default:
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                break
            }
            
            connection?.cancel()
            connection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
            connection?.start()
        } catch {
            print(error)
        }
    }
    
    
    // MARK: NSURLConnection Delegate
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let url = connection.currentRequest.URL?.absoluteString
        
        switch url! {
        case kUrlApps:
            parseUrlApps(queue: Utils.GlobalUserInteractiveQueue, completion: { (apps, working) -> () in
                self.updatedStateForConnection(apps, working: working)
            })
        case kUrlTravelApps:
            parseUrlApps(queue: Utils.GlobalUserInteractiveQueue, completion: { (apps, working) -> () in
                self.updatedStateForConnection(apps, working: working)
            })
        case kUrlGameApps:
            parseUrlApps(queue: Utils.GlobalUserInitiatedQueue, completion: { (apps, working) -> () in
                self.updatedStateForConnection(apps, working: working)
            })
        case kUrlGameApps:
            parseUrlApps(queue: Utils.GlobalUserInitiatedQueue, completion: { (apps, working) -> () in
                self.updatedStateForConnection(apps, working: working)
            })
        case kUrlGitHubRepos:
            parseUrlGitHubRepos(queue: Utils.GlobalUserInitiatedQueue, completion: { (repos, error) -> () in
                self.delegate?.connectionReposFinished(repos, error: error)
            })
        case kUrlGitHubGetToken:
            parseUrlGitHubGetToken(queue: Utils.GlobalUserInitiatedQueue, completion: { accessToken -> () in
                self.delegate?.connectionGetTokenFinished(accessToken)
            })
        default:
            break
        }
    }
    
    private func updatedStateForConnection(apps: [App]?, working: Bool) {
        guard working else {
            self.delegate?.connectionAppsFinished(apps)
            return
        }
        self.delegate?.connectionAppsInProgress()
    }
    
    private func parseUrlApps(queue queue: dispatch_queue_t, completion: (apps: [App]?, working: Bool) -> ()) {
        dispatch_async(queue) { () -> Void in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    //print(json)
                    
                    guard let apps = json["results"] as? Array<NSDictionary> else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(apps: nil, working: false)
                        })
                        return
                    }
                    
                    var appsStored: [App]?
                    for app: AnyObject in apps {
                        guard let title = app["trackCensoredName"] as? String else {
                            continue
                        }
                        guard let url = app["trackViewUrl"] as? String else {
                            continue
                        }
                        guard let logo = app["artworkUrl100"] as? String else {
                            continue
                        }
                        
                        let appStored = App(title: title, url: url, logo: logo)
                        
                        guard let _ = appsStored else {
                            appsStored = [appStored]
                            continue
                        }
                        appsStored?.append(appStored)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(apps: appsStored, working: true)
                        })
                        //print(app)
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(apps: appsStored, working: false)
                    })
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func parseUrlGitHubRepos(queue queue: dispatch_queue_t, completion: (repos: [Repo]?, error: NSError?) -> ()) {
        dispatch_async(queue) { () -> Void in
            do {
                if let repos = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as? Array<NSDictionary> {
                    //let jsonResult: Array<NSDictionary>?
                    print(repos)
                    
                    var reposStored: [Repo]?
                    for repo: AnyObject in repos {
                        guard let id = repo["id"] as? Int else {
                            continue
                        }
                        guard let name = repo["name"] as? String else {
                            continue
                        }
                        guard let description = repo["description"] as? String else {
                            continue
                        }
                        guard let url = repo["url"] as? String else {
                            continue
                        }
                        
                        let repoStored = Repo(id: "\(id)", name: name, description: description, ownerLogin: "", url: url)
                        
                        guard let _ = reposStored else {
                            reposStored = [repoStored]
                            continue
                        }
                        reposStored?.append(repoStored)
                        /*
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(repos: reposStored, working: true)
                        })
                        */
                        //print(app)
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(repos: reposStored, error: nil)
                    })
                } else if let error = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    print(error)
                    
                    guard let message = error["message"] as? String else {
                        return
                    }
                    
                    switch message {
                    case kErrorMessageGitHubBadCredentials:
                        KeychainWrapper.removeObjectForKey(kKeychainKeyGitHub)
                        let cError = NSError(domain: kErrorDomainConnection, code: kErrorCodeGitHubBadCredentials, userInfo: [NSLocalizedDescriptionKey: kErrorMessageGitHubBadCredentials, NSLocalizedRecoverySuggestionErrorKey: kErrorMessageLogInAgain])
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(repos: nil, error: cError)
                        })
                    default:
                        break;
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func parseUrlGitHubGetToken(queue queue: dispatch_queue_t, completion: (accessToken: String?) -> ()) {
        dispatch_async(queue) { () -> Void in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    print(json)
                    
                    var accessToken: String?
                    
                    if let paramAccessToken = json["access_token"] as? String {
                        accessToken = paramAccessToken
                    }
                    // TODO: Verify SCOPE
                    // TODO: Verify TOKEN_TYPE is BARIER
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(accessToken: accessToken)
                    })
                }
            } catch {
                if let completionHandler = self.connectionCompletionHandler {
                    let cError = NSError(domain: kErrorDomainConnection, code: kErrorCodeJSONSerialization, userInfo: [NSLocalizedDescriptionKey: kErrorMessageJSONSerialize, NSLocalizedRecoverySuggestionErrorKey: kErrorMessageRetryRequest])
                    completionHandler(nil, cError)
                }
                print("Error: \(error)")
            }
        }
    }
}