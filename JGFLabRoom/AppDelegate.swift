//
//  AppDelegate.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// MARK: IMPORTANT: Facebook SDK
// In order to use this SDK, you'll need to download it first and follow the instructions provided by Facebook in the following link:
//
// Ref.: https://developers.facebook.com/docs/ios/getting-started
// Ref.2: https://origincache.facebook.com/developers/resources/?id=facebook-ios-sdk-current.zip
//
// If you are not interested on Facebook stuff, just comment imports and methods of Facebook SDK
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // We'll clean up our cache before enter on Background Mode.
        ImageHelper.sharedInstance.cleanCache()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {        
        GitHubAPIManager.sharedInstance.processOAuthStep1Response(url)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        // MARK: IMPORTANT!
        // This method isn't going to be called because application(:url:sourceApplication:annotation:) will handle the triggered event from Safari
        GitHubAPIManager.sharedInstance.processOAuthStep1Response(url)
        return true
    }
}

