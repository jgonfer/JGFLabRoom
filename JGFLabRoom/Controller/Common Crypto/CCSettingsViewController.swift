//
//  CCSettingsViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 22/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

protocol CCSettingsViewControllerDelegate {
    func valueSelected(row: Int)
}

class CCSettingsViewController: UITableViewController {
    var delegate: CCSettingsViewControllerDelegate?
    
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
            return 0
        }
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell!.textLabel!.text = results![indexPath.row]
        cell?.accessoryType = .None
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.valueSelected(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}