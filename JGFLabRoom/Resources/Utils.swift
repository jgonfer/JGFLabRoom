//
//  Utils.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 14/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit
import Foundation

let userDefaults = NSUserDefaults.standardUserDefaults()

class Utils {
    
    // MARK: GENERAL
    
    static var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    static var GlobalUserInteractiveQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    }
    static var GlobalUserInitiatedQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }
    static var GlobalUtilityQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    }
    static var GlobalBackgroundQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }
    
    
    // MARK: TABLEVIEW Management
    
    class func registerStandardXibForTableView(tableView: UITableView, name: String) {
        // Registration of a standard UITableViewCell with identifier @name. It'll have standard parameters like cell.textLabel, cell.detailTextLabel and cell.imageView
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: name)
    }
    
    class func registerCustomXibForTableView(tableView: UITableView, name: String) {
        // Registration of a new Nib with identifier @name
        tableView.registerNib(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    // MARK: NAVIGATION BAR Management
    
    class func cleanBackButtonTitle(nav: UINavigationController?) {
        // Replacement of the existing button in the navigationBar
        nav?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
    }
    
    
    // MARK: DATES Management
    
    class func getStartEndDateForYear(year: Int) -> (NSDate, NSDate)? {
        // We get the @year period by setting the start date of the @year, and the end date of the @year
        let startDateString = "\(year)-01-01"
        let endDateString = "\(year)-12-31"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let startDate = dateFormatter.dateFromString(startDateString) else {
            return nil
        }
        guard let endDate = dateFormatter.dateFromString(endDateString) else {
            return nil
        }
        return (startDate, endDate)
    }
    
    class func getWeekdayThreeCharsFromDate(date: NSDate) -> String {
        // Request for the three first characters of the weekday (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEE"
        
        return dayTimePeriodFormatter.stringFromDate(date).uppercaseString
    }
    
    class func getWeekdayNameFromDate(date: NSDate) -> String {
        // Request for the full name of the weekday (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE"
        
        return dayTimePeriodFormatter.stringFromDate(date).capitalizedString
    }
    
    class func getMonthThreeCharsFromDate(date: NSDate) -> String {
        // Request for the three first characters of the month (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM"
        
        return dayTimePeriodFormatter.stringFromDate(date).uppercaseString
    }
    
    class func getMonthNameFromDate(date: NSDate) -> String {
        // Request for the full name of the month (Localized)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM"
        
        return dayTimePeriodFormatter.stringFromDate(date).capitalizedString
    }
    
    class func getMonthsArraysForEvents(events: [[String:String]]?) -> (months: [String]?, eventsSorted: [[[String:String]]]?) {
        // Check that we have events to iterate
        guard let events = events else {
            return (nil, nil)
        }
        var months: [String]?
        var eventsSorted: [[[String:String]]]?
        for event in events {
            // Check that the event has a date to use
            guard let dateString = event["date"] else {
                continue
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            // @col is a counter to control the months that we add to our @eventStore array
            var col = 0
            // Check that there is a valid date
            if let date = dateFormatter.dateFromString(dateString) {
                let month = getMonthNameFromDate(date)
                // Check if the @months array is initialized
                guard let _ = months else {
                    // If isn't initialized, we initialize the array with the first month and @eventStore with the @event that we have
                    months = [month]
                    eventsSorted = [[event]]
                    // Let's keep going on next iteration
                    continue
                }
                // Check if @months array contains the month of the current @event
                guard months!.contains(month) else {
                    // If it isn't contained, we increment @col
                    col++
                    // We also add the current @month (Month's name) to @months
                    months?.append(month)
                    // And finally we add a new array initialized with the current @event to @eventSorted. 
                    eventsSorted?.append([event])
                    // Our intention is to represent the new position @col of the array like a new month store in the array @eventStored. This kind of order will help us in the future when we'll display the array in our tableView providing this array as the data source.
                    
                    // Let's keep going on next iteration
                    continue
                }
                eventsSorted![col].append(event)
            }
        }
        return (months, eventsSorted)
    }
    
    
    // MARK: COMMON CRYPTO Management ()
    // MARK: Read this
    // 1) To get working Common Crypto you need implement a Bridging-Header.h in your project
    // 2) Then, import in this new file the library with this line: "#import <CommonCrypto/CommonCrypto.h>"
    // 3) For last but not less, go to the tab "Build Settings" in your project and search "Bridging Header". In the row result named "Objective-C Bridging Header", type the path of your Bridging Header file. In this project is "JGFLabRoom/Resources/JGFLabRoom-Bridging-Header.h". You can check it by navigating through folders in Finder.
    // Et voilà! Xcode will recognize everything related to Common Crypto
    
    class func generateRandomStringKey() -> String {
        
        let bytesCount = 4 // number of bytes
        var randomNum = ""
        var randomBytes = [UInt8](count: bytesCount, repeatedValue: 0) // array to hold randoms bytes
        
        // Gen random bytes
        SecRandomCopyBytes(kSecRandomDefault, bytesCount, &randomBytes)
        
        // Turn randomBytes into array of hexadecimal strings
        // Join array of strings into single string
        randomNum = randomBytes.map({String(format: "%04hhx", $0)}).joinWithSeparator("")
        return randomNum
    }
    
    static func AESEncryption(message: String, key: String, algorithm: Int, blockSize: Int, contextSize: Int, keySize: Int, option: Int) -> (data: NSData, text: String)? {
        let keyString        = key
        let keyData: NSData! = (keyString as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let keyBytes         = UnsafeMutablePointer<Void>(keyData.bytes)
        print("keyLength   = \(keyData.length), keyData   = \(keyData)")
        
        let message       = message
        let data: NSData! = (message as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeMutablePointer<Void>(data.bytes)
        print("dataLength  = \(dataLength), data      = \(data)")
        
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSizeAES128)
        let cryptPointer = UnsafeMutablePointer<Void>(cryptData!.mutableBytes)
        let cryptLength  = size_t(cryptData!.length)
        
        let keyLength              = size_t(kCCKeySizeAES128)
        let operation: CCOperation = UInt32(kCCEncrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding + kCCOptionECBMode)
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation,
            algoritm,
            options,
            keyBytes, keyLength,
            nil,
            dataBytes, dataLength,
            cryptPointer, cryptLength,
            &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            //  let x: UInt = numBytesEncrypted
            cryptData!.length = Int(numBytesEncrypted)
            print("cryptLength = \(numBytesEncrypted), cryptData = \(cryptData)")
            
            // Not all data is a UTF-8 string so Base64 is used
            let base64cryptString = cryptData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            print("base64cryptString = \(base64cryptString)")
            return (cryptData!, base64cryptString)
            
        } else {
            print("Error: \(cryptStatus)")
            return nil
        }
    }
    
    static func AESDecryption(data:NSData, key: String, algorithm: Int, blockSize: Int, contextSize: Int, keySize: Int, option: Int) -> (data: NSData, text: String)? {
        let keyString        = key
        let keyData: NSData! = (keyString as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let keyBytes         = UnsafeMutablePointer<Void>(keyData.bytes)
        print("keyLength   = \(keyData.length), keyData   = \(keyData)")
        
        //let message       = "Don´t try to read this text. Top Secret Stuff"
        // let data: NSData! = (message as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeMutablePointer<Void>(data.bytes)
        print("dataLength  = \(dataLength), data      = \(data)")
        
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSizeAES128)
        let cryptPointer = UnsafeMutablePointer<Void>(cryptData!.mutableBytes)
        let cryptLength  = size_t(cryptData!.length)
        
        let keyLength              = size_t(kCCKeySizeAES128)
        let operation: CCOperation = UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding + kCCOptionECBMode)
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation,
            algoritm,
            options,
            keyBytes, keyLength,
            nil,
            dataBytes, dataLength,
            cryptPointer, cryptLength,
            &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            //  let x: UInt = numBytesEncrypted
            cryptData!.length = Int(numBytesEncrypted)
            print("DecryptcryptLength = \(numBytesEncrypted), Decrypt = \(cryptData)")
            
            // Not all data is a UTF-8 string so Base64 is used
            let base64cryptString = cryptData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            print("base64DecryptString = \(base64cryptString)")
            print( "utf8 actual string = \(NSString(data: cryptData!, encoding: NSUTF8StringEncoding))");
            return (cryptData!, base64cryptString)
        } else {
            print("Error: \(cryptStatus)")
            return nil
        }
    }
}