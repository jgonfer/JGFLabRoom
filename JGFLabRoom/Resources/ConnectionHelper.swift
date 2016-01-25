//
//  ConnectionHelper.swift
//  JGFLabRoom
//
//  Created by Josep González on 20/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

let singletonCH = ConnectionHelper()

protocol ConnectionHelperDelegate {
    func connectionAppsInProgress()
    func connectionAppsFinished(apps: [App]?)
}

extension ConnectionHelperDelegate {
    func connectionAppsInProgress() {}
    func connectionAppsFinished(apps: [App]?) {}
}

class ConnectionHelper: NSObject, NSURLConnectionDelegate {
    var delegate: ConnectionHelperDelegate?
    var connection: NSURLConnection?
    
    class var sharedInstance: ConnectionHelper {
        return singletonCH
    }
    
    var data = NSMutableData()
    
    func getAppsFromAppStore(delegate: ConnectionHelperDelegate?) {
        self.delegate = delegate
        startConnection(kUrlApps)
    }
    
    func getTravelAppsFromAppStore(delegate: ConnectionHelperDelegate?) {
        self.delegate = delegate
        startConnection(kUrlTravelApps)
    }
    
    func getGameAppsFromAppStore(delegate: ConnectionHelperDelegate?) {
        self.delegate = delegate
        startConnection(kUrlGameApps)
    }
    
    func getGitHubRepos(delegate: ConnectionHelperDelegate?) {
        self.delegate = delegate
        startConnection(kUrlGitHubRepos)
    }
    
    
    // MARK: Connection Method
    
    private func startConnection(url: String){
        data = NSMutableData()
        let url: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        connection?.cancel()
        connection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        connection?.start()
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
            parseUrlGitHubRepos(queue: Utils.GlobalUserInitiatedQueue, completion: { (apps, working) -> () in
                self.updatedStateForConnection(apps, working: working)
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
                    //let jsonResult: Array<NSDictionary>?
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
    
    private func parseUrlGitHubRepos(queue queue: dispatch_queue_t, completion: (apps: [App]?, working: Bool) -> ()) {
        dispatch_async(queue) { () -> Void in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    //let jsonResult: Array<NSDictionary>?
                    print(json)
                    /*
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
                    */
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}