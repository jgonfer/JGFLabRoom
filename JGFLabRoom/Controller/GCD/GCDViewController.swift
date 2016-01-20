//
//  GCDViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 19/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class GCDViewController: UITableViewController {
    var results = ["QoS: User Initiated", "QoS: User Interactive"]
    var indexSelected: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        //ConnectionHelper.sharedInstance.getAppsFromAppStore(self)
    }
    
    private func setupController() {
        Utils.registerStandardXibForTableView(tableView, name: "cell")
        Utils.cleanBackButtonTitle(navigationController)
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
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell!.textLabel!.text = results[indexPath.row]
        cell?.accessoryType = .DisclosureIndicator
        
        //cell!.detailTextLabel!.text = "some text"
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
