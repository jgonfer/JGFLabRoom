//
//  KeychainViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 27/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

//////////////////////////////////////////////////
// MARK: IMPORTANT: Stop running app in background
// We can stop running our app in background by setting "Application does not run in background" to "YES" in our Info.plist
// If we have a login view at the beginning of our app, this will be displayed if the user press the Home button

// MARK: IMPORTANT: Keychain Wrapper author
// https://github.com/jrendel/SwiftKeychainWrapper
//////////////////////////////////////////////////

class KeychainViewController: UIViewController {
    @IBOutlet weak var userInput: CustomTextField!
    @IBOutlet weak var passInput: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cleanLoginButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    
    let kTagButtonCreateLogin = 10
    let kTagButtonLogin = 11
    
    let kTagTextFieldUser = 0
    let kTagTextFieldPass = 1
    
    // Old version of KeychainWrapper written in Objective-C
    //let kcPassword = MyKeychainWrapper.myObjectForKey("v_Data")
    // New version of KeychainWrapper written in Swift
    //let kLoginKey = kSecValueData
    let kLoginKey = "login"
    
    // Old version of KeychainWrapper
    //let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.cleanBackButtonTitle(navigationController)
        
        userInput.layer.borderColor = kColorPrimaryAlpha.CGColor
        userInput.layer.borderWidth = 2
        userInput.layer.masksToBounds = true
        userInput.layer.cornerRadius = 8.0
        userInput.leftTextMargin = 10
        userInput.tag = kTagTextFieldUser
        passInput.layer.borderColor = kColorPrimaryAlpha.CGColor
        passInput.layer.borderWidth = 2
        passInput.layer.masksToBounds = true
        passInput.layer.cornerRadius = 8.0
        passInput.leftTextMargin = 10
        passInput.tag = kTagTextFieldPass
        loginButton.layer.cornerRadius = 8.0
        cleanLoginButton.layer.cornerRadius = 8.0
        
        updateLoginInfo()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateLoginInfo() {
        // Check if we've created our credentials
        let hasLogin = userDefaults.boolForKey("keychainHasLogin")
        
        if hasLogin {
            // Setup UI for login state
            loginButton.setTitle("Log In", forState: .Normal)
            userLabel.text = userDefaults.valueForKey("keychainUsername") as? String
            // Old version of KeychainWrapper
            //let pass = MyKeychainWrapper.myObjectForKey(kLoginKey) as? String ?? ""
            // New version of KeychainWrapper
            guard let pass = KeychainWrapper.stringForKey(kLoginKey) else {
                cleanLoginInfo(cleanLoginButton)
                return
            }
            var passCoded = ""
            if pass.characters.count > 0 {
                for _ in 0...pass.characters.count-1 {
                    passCoded += "•"
                }
            }
            passLabel.text = passCoded
            loginButton.tag = kTagButtonLogin
            resultLabel.text = "Try to Log In!"
        } else {
            // Setup UI for create credentials state
            loginButton.setTitle("Create", forState: .Normal)
            userLabel.text = "---"
            passLabel.text = "---"
            resultLabel.text = "Create your credentials"
            loginButton.tag = kTagButtonCreateLogin
        }
        
        userInput.text = ""
        passInput.text = ""
    }
    
    func dismissKeyboard() {
        // Stop focus on both textfields
        userInput.resignFirstResponder()
        passInput.resignFirstResponder()
    }
    
    private func checkLogin() -> Bool {
        let kcUsername = userDefaults.valueForKey("keychainUsername")
        // Old version of KeychainWrapper
        //let kcPassword = MyKeychainWrapper.myObjectForKey("v_Data")
        // New version of KeychainWrapper
        
        // Check if there is a Password set in our Keychain
        guard let kcPassword = KeychainWrapper.stringForKey(kLoginKey) else {
            return false
        }
        // Check if our credentials match what the user has written in the textfields
        guard userInput.text! == kcUsername as? String && passInput.text! == kcPassword else {
            return false
        }
        return true
    }
    
    @IBAction func logIn(sender: UIButton) {
        dismissKeyboard()
        
        let user = userInput.text!
        let pass = passInput.text!
        var message = ""
        
        switch (user, pass) {
        case ("", ""):
            message = "Fill both fields"
        case ("", pass):
            message = "Fill Username field"
        case (user, ""):
            message = "Fill Password field"
        default:
            break
        }
        
        // Check if both textfields have text
        guard !userInput.text!.isEmpty && !passInput.text!.isEmpty else {
            resultLabel.text = message
            resultLabel.textColor = kColorWrong
            return
        }
        
        // Check if we are doing the login process
        guard sender.tag == kTagButtonLogin else {
            // If not we are creating new credentials to log in later
            let hasLogin = userDefaults.boolForKey("keychainHasLogin")
            if !hasLogin {
                userDefaults.setValue(user, forKey: "keychainUsername")
            }
            userDefaults.setBool(true, forKey: "keychainHasLogin")
            userDefaults.synchronize()
            
            // Old version of KeychainWrapper
            //MyKeychainWrapper.mySetObject(pass, forKey: kLoginKey)
            //MyKeychainWrapper.writeToKeychain()
            // New version of KeychainWrapper
            guard KeychainWrapper.setString(pass, forKey: kLoginKey) else {
                cleanLoginInfo(cleanLoginButton)
                return
            }
            
            sender.tag = kTagButtonLogin
            
            updateLoginInfo()
            
            return
        }
        
        let success = self.checkLogin()
        
        // Show result of the login process
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.resultLabel.alpha = 0
            }, completion: { (Bool) -> Void in
                
                UIView.animateWithDuration(0.75, animations: { () -> Void in
                    self.resultLabel.text = success ? "Success!" : "Failed"
                    self.resultLabel.textColor = success ? kColorPrimary : kColorWrong
                    self.resultLabel.alpha = 1
                })
        })
    }
    @IBAction func cleanLoginInfo(sender: UIButton) {
        userDefaults.setBool(false, forKey: "keychainHasLogin")
        userDefaults.setValue("", forKey: "keychainUsername")
        userDefaults.synchronize()
        
        // Old version of KeychainWrapper
        //MyKeychainWrapper.mySetObject("", forKey: kLoginKey)
        //MyKeychainWrapper.writeToKeychain()
        // New version of KeychainWrapper
        KeychainWrapper.removeObjectForKey(kLoginKey)
        
        updateLoginInfo()
    }
}

// MARK: UITextField Delegate
extension KeychainViewController: UITextFieldDelegate {
    // We need to handle when the user press Next button or Done button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Stop focus the current textfield
        textField.resignFirstResponder()
        
        // Check if the current textfield is the Password textfield with the Done button
        guard textField.tag == kTagTextFieldPass else {
            // If not we focus on the next textfield
            if let view = view.viewWithTag(textField.tag + 1) {
                view.becomeFirstResponder()
            }
            return true
        }
        
        // If it's the PAssword texfield we start the login process
        logIn(loginButton)
        return true
    }
}
