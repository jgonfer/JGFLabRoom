//
//  ListAppsViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 20/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class ListAppsViewController: UITableViewController {
    var dots = 0
    var results: [App]?
    var indexSelected: NSIndexPath?
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        
        guard let indexSelected = indexSelected else {
            return
        }
        
        switch indexSelected.row {
        case 0:
            title = "Top 200 Games"
            ConnectionHelper.sharedInstance.getGameAppsFromAppStore(self)
        case 1:
            title = "Top 200 Travel"
            ConnectionHelper.sharedInstance.getTravelAppsFromAppStore(self)
        default:
            title = "My Apps"
            ConnectionHelper.sharedInstance.getAppsFromAppStore(self)
            break
        }
    }
    
    deinit {
        cancelTimerDownloading()
    }
    
    private func setupController() {
        Utils.registerStandardXibForTableView(tableView, name: "cell")
        Utils.cleanBackButtonTitle(navigationController)
        startTimerDownloading()
    }
    
    private func startTimerDownloading() {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkDownloadingState", userInfo: nil, repeats: true)
    }
    
    private func cancelTimerDownloading() {
        timer?.invalidate()
    }
    
    func checkDownloadingState() {
        dots++
        if dots > 3 {
            dots = 0
        }
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
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
            return 1
        }
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        guard let results = results else {
            var dotsStr = ""
            var counter = 0
            while counter < dots {
                dotsStr += "."
                counter++
            }
            cell!.textLabel!.text = "Downloading data" + dotsStr
            return cell!
        }
        cell!.textLabel!.text = results[indexPath.row].title
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

extension ListAppsViewController: ConnectionHelperDelegate {
    func connectionAppsFinished(apps: [App]?) {
        results = apps
        cancelTimerDownloading()
        tableView.reloadData()
    }
}
