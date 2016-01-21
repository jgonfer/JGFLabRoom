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
            ConnectionHelper.sharedInstance.getAppsFromAppStore(self)
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
        
        var title: String {
            guard let results = results else {
                var dotsStr = ""
                var counter = 0
                while counter < dots {
                    dotsStr += "."
                    counter++
                }
                return "Downloading data" + dotsStr
            }
            return results[indexPath.row].title
        }
        cell?.textLabel?.text = title
        cell?.accessoryType = .None
        
        guard let results = results else {
            return cell!
        }
        ImageHelper.sharedInstance.imageForUrl(results[indexPath.row].logo, completionHandler:{(image: UIImage?, url: String) in
            guard let image = image else {
                return
            }
            if let cell = cell {
            cell.imageView?.image = image
            cell.imageView?.layer.cornerRadius = 10.0
            cell.imageView?.clipsToBounds = true
            let heightCell = cell.frame.height
            cell.imageView?.frame.size = CGSizeMake(heightCell*0.75, heightCell*0.75)
            cell.layoutSubviews()
            }
        })
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.indexSelected = indexPath
        //performSegueWithIdentifier(kSegueIdListApps, sender: tableView)
        
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
        guard let _ = indexSelected else {
            results?.sortInPlace({ $0.title < $1.title })
            tableView.reloadData()
            return
        }
        tableView.reloadData()
    }
}
