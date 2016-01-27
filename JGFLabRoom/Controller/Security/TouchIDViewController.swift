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
    let kMsgFingerOK = "Fingerprint recognized! ✅"
    var context = LAContext()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateUI", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    private func setupController() {
        Utils.cleanBackButtonTitle(navigationController)
        
        updateUI()
    }
    
    func updateUI() {
        var err: NSError?
        guard context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &err) else {
            
            image.image = UIImage(named: "TouchID_off")
            message.text = err?.localizedDescription
            return
        }
        
        image.image = UIImage(named: "TouchID_on")
        message.text = kMsgShowFinger
        
        context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: kMsgShowFinger) {
            (success: Bool, error: NSError?) -> Void in
            
            dispatch_async(Utils.GlobalMainQueue, { () -> Void in
                guard success else {
                    if error != nil {
                        switch(error!.code) {
                        case LAError.AuthenticationFailed.rawValue:
                            self.message.text = "There was a problem verifying your identity."
                        case LAError.UserCancel.rawValue:
                            self.message.text = "You pressed cancel."
                        case LAError.UserFallback.rawValue:
                            self.message.text = "You pressed password."
                        // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                        default:
                            self.message.text = "Touch ID may not be configured"
                            break
                        }
                    }
                    return
                }
                
                self.message.text = self.kMsgFingerOK
            })
        }
    }
}
