//
//  CommonCryptoViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 21/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//


import UIKit

class CommonCryptoViewController: UIViewController {
    @IBOutlet weak var topInput: UITextView!
    @IBOutlet weak var bottomInput: UITextView!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var originalMessageLabel: UITextView!
    @IBOutlet weak var base64DecryptTitleLabel: UILabel!
    @IBOutlet weak var base64DecryptMessageLabel: UITextView!
    @IBOutlet weak var CCAlgorithmButton: UIButton!
    @IBOutlet weak var CCBlockSizeButton: UIButton!
    @IBOutlet weak var CCContextSizeButton: UIButton!
    @IBOutlet weak var CCKeySizeButton: UIButton!
    @IBOutlet weak var CCOptionButton: UIButton!
    @IBOutlet weak var fixedStringSwitch: UISwitch!
    
    var randomKey = Utils.generateRandomStringKey()
    var dataEncryptedMessage: NSData?
    var settingsType: SettingAES?
    var tagSelected: Int?
    var titlesEncryption = ["AES 128", "AES 128", "AES 128", "AES 128", "PKCS7 Padding"]
    var valuesEncryption = [kCCAlgorithmAES128, kCCBlockSizeAES128, kCCContextSizeAES128, kCCKeySizeAES128, kCCOptionPKCS7Padding]
    
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
        originalMessageLabel.text = randomKey
        
        updateTitleButtons()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateTitleButtons() {
        CCAlgorithmButton.setTitle(titlesEncryption[0], forState: .Normal)
        CCBlockSizeButton.setTitle(titlesEncryption[1], forState: .Normal)
        CCContextSizeButton.setTitle(titlesEncryption[2], forState: .Normal)
        CCKeySizeButton.setTitle(titlesEncryption[3], forState: .Normal)
        CCOptionButton.setTitle(titlesEncryption[4], forState: .Normal)
    }
    
    func dismissKeyboard() {
        topInput.resignFirstResponder()
        bottomInput.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let settingsType = settingsType else {
            return
        }
        if let vcToShow = segue.destinationViewController as? CCSettingsViewController {
            vcToShow.settingsType = settingsType
            vcToShow.title = SettingAES.getTitle(settingsType)
            vcToShow.delegate = self
        }
    }
    
    // MARK: IBAction Methods
    
    @IBAction func chooseSettingsForAESEncryption(sender: UIButton) {
        switch sender.tag {
        case 0:
            settingsType = .CCAlgorithm
        case 1:
            settingsType = .CCBlockSize
        case 2:
            settingsType = .CCContextSize
        case 3:
            settingsType = .CCKeySize
        case 4:
            settingsType = .CCOption
        default:
            break
        }
        tagSelected = sender.tag
        performSegueWithIdentifier(kSegueIdCCSettings, sender: sender)
    }
    
    @IBAction func encryptMessage(sender: UIButton) {
        guard !topInput.text!.isEmpty else {
            return
        }
        if !fixedStringSwitch.on {
            randomKey = Utils.generateRandomStringKey()
        }
        originalMessageLabel.text = randomKey
        if let messageEncrypted = Utils.AESEncryption(topInput.text!, key: randomKey, algorithm: valuesEncryption[0], blockSize: valuesEncryption[1], contextSize: valuesEncryption[2], keySize: valuesEncryption[3], option: valuesEncryption[4]) {
            dataEncryptedMessage = messageEncrypted.data
            bottomInput.text = messageEncrypted.text
            dismissKeyboard()
        } else {
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
        originalMessageLabel.text = randomKey
        if let messageEncrypted = Utils.AESDecryption(dataEncryptedMessage, key: randomKey, algorithm: valuesEncryption[0], blockSize: valuesEncryption[1], contextSize: valuesEncryption[2], keySize: valuesEncryption[3], option: valuesEncryption[4]) {
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
    }
}

extension CommonCryptoViewController: CCSettingsViewControllerDelegate {
    func valueSelected(row: Int) {
        let titles = SettingAES.getTitlesArray(settingsType!)
        let values = SettingAES.getValuesArray(settingsType!)
        titlesEncryption[tagSelected!] = titles[row]
        valuesEncryption[tagSelected!] = values[row]
        
        updateTitleButtons()
    }
}
