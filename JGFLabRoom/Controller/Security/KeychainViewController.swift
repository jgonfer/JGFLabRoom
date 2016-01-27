//
//  KeychainViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 27/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class KeychainViewController: UIViewController {
    @IBOutlet weak var userInput: CustomTextField!
    @IBOutlet weak var passInput: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cleanLoginButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    
    let MyKeychainWrapper = KeychainWrapper()
    let kTagButtonCreateLogin = 10
    let kTagButtonLogin = 11
    
    let kTagTextFieldUser = 0
    let kTagTextFieldPass = 1
    
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
        let hasLogin = userDefaults.boolForKey("keychainHasLogin")
        
        if hasLogin {
            loginButton.setTitle("Log In", forState: .Normal)
            userLabel.text = userDefaults.valueForKey("keychainUsername") as? String
            let pass = MyKeychainWrapper.myObjectForKey("v_Data") as! String
            var passCoded = ""
            for _ in 0...pass.characters.count-1 {
                passCoded += "•"
            }
            passLabel.text = passCoded
            loginButton.tag = kTagButtonLogin
            resultLabel.text = "Try to Log In!"
        } else {
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
        userInput.resignFirstResponder()
        passInput.resignFirstResponder()
    }
    
    private func checkLogin() -> Bool {
        let kcUsername = userDefaults.valueForKey("keychainUsername")
        let kcPassword = MyKeychainWrapper.myObjectForKey("v_Data")
        guard userInput.text! == kcUsername as? String && passInput.text! == kcPassword as? String else {
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
        
        guard !userInput.text!.isEmpty && !passInput.text!.isEmpty else {
            resultLabel.text = message
            resultLabel.textColor = kColorWrong
            return
        }
        
        guard sender.tag == kTagButtonLogin else {
            let hasLogin = userDefaults.boolForKey("keychainHasLogin")
            if !hasLogin {
                userDefaults.setValue(user, forKey: "keychainUsername")
            }
            userDefaults.setBool(true, forKey: "keychainHasLogin")
            userDefaults.synchronize()
            
            MyKeychainWrapper.mySetObject(pass, forKey: kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            sender.tag = kTagButtonLogin
            
            updateLoginInfo()
            
            return
        }
        
        let success = self.checkLogin()
        
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
        
        MyKeychainWrapper.mySetObject("", forKey: kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        
        updateLoginInfo()
    }
}

extension KeychainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard textField.tag == kTagTextFieldPass else {
            if let view = view.viewWithTag(textField.tag + 1) {
                view.becomeFirstResponder()
            }
            return true
        }
        
        logIn(loginButton)
        return true
    }
}
