//
//  TouchIDViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 27/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    let kMsgShowFinger = "Show me your finger 👍"
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    let kMsgFingerOK = "Login successful! ✅"
    var context = LAContext()
    
    deinit {
        Utils.removeObserverForNotifications(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.cleanBackButtonTitle(navigationController)
        Utils.registerNotificationWillEnterForeground(self, selector: "updateUI")
        
        // Add right button in the navigation bar to repeat the login process so many times as we want
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "updateUI")
    }
    
    func updateUI() {
        // Initialize our context object just in this example, in a real app it shouldn't be necessary. In fact, we should avoid this initialization
        // The reason is because once our LAContext detects that the login was successfully done, it won't let us repeat the login process again
        context = LAContext()
        
        var policy: LAPolicy?
        // Depending the iOS version we've selected properly policy system that the user is able to do
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .DeviceOwnerAuthentication
        } else {
            // iOS 9+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = "Fuu!"
            policy = .DeviceOwnerAuthenticationWithBiometrics
        }
        
        var err: NSError?
        
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            image.image = UIImage(named: "TouchID_off")
            // Print the localized message received by the system
            message.text = err?.localizedDescription
            return
        }
        
        // Great! The user is able to use his/her Touch ID 👍
        image.image = UIImage(named: "TouchID_on")
        message.text = kMsgShowFinger
        
        loginProcess(policy!)
    }
    
    private func loginProcess(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: kMsgShowReason) {
            (success: Bool, error: NSError?) -> Void in
            
            dispatch_async(Utils.GlobalMainQueue, { () -> Void in
                guard success else {
                    if error != nil {
                        switch(error!.code) {
                        case LAError.AuthenticationFailed.rawValue:
                            self.message.text = "There was a problem verifying your identity."
                        case LAError.UserCancel.rawValue:
                            self.message.text = "You pressed cancel."
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                        // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                        case LAError.UserFallback.rawValue:
                            self.message.text = "You pressed Fuu!."
                        // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                        default:
                            self.message.text = "Touch ID may not be configured"
                            break
                        }
                    }
                    return
                }
                
                // Good news! Everything went fine 👏
                self.message.text = self.kMsgFingerOK
            })
        }
    }
}
