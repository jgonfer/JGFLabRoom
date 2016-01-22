//
//  CCSettingsViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 22/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class CCSettingsViewController: UITableViewController {
    var results: [String]?
    var resultsValue: [Int]?
    
    var settingsType = SettingAES.CCAlgorithm
    var indexSelected: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.registerStandardXibForTableView(tableView, name: "cell")
        Utils.cleanBackButtonTitle(navigationController)
        
        switch settingsType {
        case .CCAlgorithm:
            results = SettingAES.getTitlesArray(.CCAlgorithm)
            resultsValue = SettingAES.getValuesArray(.CCAlgorithm)
        case .CCBlockSize:
            results = SettingAES.getTitlesArray(.CCBlockSize)
            resultsValue = SettingAES.getValuesArray(.CCBlockSize)
        case .CCContextSize:
            results = SettingAES.getTitlesArray(.CCContextSize)
            resultsValue = SettingAES.getValuesArray(.CCContextSize)
        case .CCKeySize:
            results = SettingAES.getTitlesArray(.CCKeySize)
            resultsValue = SettingAES.getValuesArray(.CCKeySize)
        case .CCOption:
            results = SettingAES.getTitlesArray(.CCOption)
            resultsValue = SettingAES.getValuesArray(.CCOption)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexSelected = indexSelected else {
            return
        }
        switch segue.identifier! {
        case kSegueIdListApps:
            if let vcToShow = segue.destinationViewController as? ListAppsViewController {
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
        guard let results = results else {
            navigationController?.popToRootViewControllerAnimated(true)
        }
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        var title: String {
            switch settingsType {
            case .CCAlgorithm:
                return resultsCCAlgorithm[indexPath.row] as! String
            case .CCBlockSize:
                return resultsCCBlockSize[indexPath.row] as! String
            case .CCContextSize:
                return resultsCCContextSize[indexPath.row] as! String
            case .CCKeySize:
                return resultsCCKeySize[indexPath.row] as! String
            case .CCOption:
                return resultsCCOption[indexPath.row] as! String
            }
        }
        
        cell!.textLabel!.text = results[indexPath.row]
        cell?.accessoryType = .None
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.indexSelected = indexPath
        performSegueWithIdentifier(kSegueIdListApps, sender: tableView)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}