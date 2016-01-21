//
//  CommonCryptoViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 21/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//


import UIKit

class CommonCryptoViewController: UIViewController {
    @IBOutlet weak var topInput: UITextField!
    @IBOutlet weak var bottomInput: UITextField!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var originalMessageLabel: UILabel!
    @IBOutlet weak var base64DecryptTitleLabel: UILabel!
    @IBOutlet weak var base64DecryptMessageLabel: UILabel!
    
    var randomKey = ""
    var dataEncryptedMessage: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.cleanBackButtonTitle(navigationController)
        topInput.layer.borderColor = kColorPrimary.CGColor
        topInput.layer.borderWidth = 2
        topInput.layer.masksToBounds = true
        topInput.layer.cornerRadius = 8.0
        bottomInput.layer.borderColor = kColorPrimaryAlpha.CGColor
        bottomInput.layer.borderWidth = 2
        bottomInput.layer.masksToBounds = true
        bottomInput.layer.cornerRadius = 8.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        topInput.resignFirstResponder()
        bottomInput.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBAction Methods
    
    @IBAction func encryptMessage(sender: UIButton) {
        guard !topInput.text!.isEmpty else {
            return
        }
        randomKey = Utils.generateRandomStringKey()
        if let messageEncrypted = Utils.AES128Encryption(topInput.text!, key: randomKey) {
            dataEncryptedMessage = messageEncrypted.data
            originalTitleLabel.hidden = false
            originalMessageLabel.text = topInput.text!
            bottomInput.text = messageEncrypted.text
            dismissKeyboard()
        } else {
            originalTitleLabel.hidden = true
            originalMessageLabel.text = ""
            bottomInput.text = ""
        }
    }
    
    @IBAction func cleanOriginalText(sender: UIButton) {
        topInput.text = ""
        base64DecryptTitleLabel.hidden = true
        base64DecryptMessageLabel.text = ""
    }
    
    @IBAction func decryptMessage(sender: UIButton) {
        guard !bottomInput.text!.isEmpty else {
            return
        }
        guard let dataEncryptedMessage = dataEncryptedMessage else {
            return
        }
        originalTitleLabel.hidden = true
        originalMessageLabel.text = ""
        if let messageEncrypted = Utils.AES128Decryption(dataEncryptedMessage, key: randomKey) {
            base64DecryptTitleLabel.hidden = false
            base64DecryptMessageLabel.text = messageEncrypted.text
            topInput.text = NSString(data: messageEncrypted.data, encoding: NSUTF8StringEncoding) as? String
            dismissKeyboard()
        } else {
            base64DecryptTitleLabel.hidden = true
            base64DecryptMessageLabel.text = ""
            topInput.text = ""
        }
    }
    
    @IBAction func cleanEncryptedText(sender: UIButton) {
        bottomInput.text = ""
        originalTitleLabel.hidden = true
        originalMessageLabel.text = ""
    }
}
