//
//  SocialOptionsViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 25/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// MARK: IMPORTANT: Facebook Login Process
// In this example we are using methods from the FBSDKLoginManager to log in and log out our user.
// In addition, there is code commented to show how would be adding the standard Login button provided by Facebook.
//
// Ref.: https://developers.facebook.com/docs/reference/ios/current/class/FBSDKLoginManager/
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SocialOptionsViewController: UITableViewController {
    let FBLoginManager = FBSDKLoginManager()
    // We could add a standard button provided by Facebook that we could customize later
    //let fbLoginButton = FBSDKLoginButton()
    
    var networkSelected: SNetworks?
    var results: [String]?
    var segues = SNetworks.segues
    var indexSelected: NSIndexPath?
    var isOAuthLoginInProcess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.registerNotificationWillEnterForeground(self, selector: "refreshUI")
        Utils.registerStandardXibForTableView(tableView, name: "cell")
        Utils.cleanBackButtonTitle(navigationController)
        if let networkSelected = networkSelected {
            results = SNetworks.getOptionsArray(networkSelected)
        }
        
        guard let networkSelected = networkSelected else {
            return
        }
        
        switch networkSelected {
        case .Facebook:
            /*
             * This lines are in case you want to implement the standard button provided by Facebook in the framework FBSDKLoginKit
             *
            fbLoginButton.center = view.center
            fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
            fbLoginButton.delegate = self
            view.addSubview(fbLoginButton)
            */
            break
        default:
            break;
        }
    }
    
    func refreshUI() {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let networkSelected = networkSelected else {
            return
        }
        switch networkSelected {
        case .GitHub:
            if let vcToShow = segue.destinationViewController as? SGitHubViewController {
                vcToShow.indexSelected = indexSelected
            }
        default:
            break
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = results else {
            return 0
        }
        return results!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell!.textLabel!.text = results![indexPath.row]
        
        var hasOAuthToken = false
        if let networkSelected = networkSelected {
            switch networkSelected {
            case .Facebook:
                hasOAuthToken = FBSDKAccessToken.currentAccessToken() != nil
            case .GitHub:
                hasOAuthToken = GitHubAPIManager.sharedInstance.hasOAuthToken()
            default:
                break;
            }
        }
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = hasOAuthToken ? "Logged in!" : results![indexPath.row]
            if isOAuthLoginInProcess {
                cell?.textLabel?.text = "Logging in..."
            }
            cell?.textLabel?.alpha = hasOAuthToken ? 0.3 : 1
            cell?.accessoryType = .None
        default:
            cell?.textLabel?.alpha = hasOAuthToken ? 1 : 0.3
            cell?.accessoryType = hasOAuthToken ? .DisclosureIndicator : .None
            break;
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let networkSelected = networkSelected else {
            return
        }
        guard let segue = segues[networkSelected.hashValue] else {
            self.indexSelected = nil
            return
        }
        guard !isOAuthLoginInProcess else {
            return
        }
        
        self.indexSelected = indexPath
        
        guard indexPath.row > 0 else {
            switch networkSelected {
            case .Facebook:
                //fbLoginButton.sendActionsForControlEvents(.TouchUpInside)
                
                guard FBSDKAccessToken.currentAccessToken() != nil else {
                    FBLoginManager.logInWithReadPermissions(
                        ["public_profile", "email", "user_friends"],
                        fromViewController: self,
                        handler: {
                            (result, error) in
                            if(error != nil){
                                print("Error during the login procress")
                            }
                            else if result.isCancelled {
                                print("Authorization cancelled by the user")
                            }
                            else {
                                // Authorization successful
                                // print(FBSDKAccessToken.currentAccessToken())
                                // No longer necessary as the token is already in the response
                                print(result.token.tokenString)
                            }
                            self.tableView.reloadData()
                    })
                    return
                }
                
                FBLoginManager.logOut()
                tableView.reloadData()
            case .GitHub:
                if GitHubAPIManager.sharedInstance.hasOAuthToken() {
                    return
                }
                
                GitHubAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
                    (error) -> Void in
                    
                    self.isOAuthLoginInProcess = false
                    
                    if let receivedError = error {
                        print(error)
                        // TODO: handle error
                        // Something went wrong, try again
                    } else {
                        // If we already have one, we'll get all repositories
                        self.tableView.reloadData()
                    }
                }
                
                isOAuthLoginInProcess = true
                GitHubAPIManager.sharedInstance.startOAuth2Login()
            default:
                break;
            }
            
            return
        }
        
        // Sig in row selected for all Services
        switch networkSelected {
        case .GitHub:
            if !GitHubAPIManager.sharedInstance.hasOAuthToken() {
                return
            }
        default:
            break;
        }
        
        performSegueWithIdentifier(segue, sender: tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SocialOptionsViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        guard result != nil else {
            print("Facebook Login")
            return
        }
        print("Facebook Login, result \(result.description)")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Facebook Logout")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}