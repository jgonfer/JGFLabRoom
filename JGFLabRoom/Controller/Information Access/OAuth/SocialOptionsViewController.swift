//
//  SocialOptionsViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 25/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class SocialOptionsViewController: UITableViewController {
    var networkSelected: SNetworks?
    var results: [String]?
    var segues = SNetworks.segues
    var indexSelected: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.registerStandardXibForTableView(tableView, name: "cell")
        Utils.cleanBackButtonTitle(navigationController)
        if let networkSelected = networkSelected {
            results = SNetworks.getOptionsArray(networkSelected)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let networkSelected = networkSelected else {
            return
        }
        switch networkSelected {
        case .GitHub:
            if let vcToShow = segue.destinationViewController as? SGitHubViewController {
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
        guard let _ = results else {
            return 0
        }
        return results!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell!.textLabel!.text = results![indexPath.row]
        /*
        cell?.accessoryType = .None
        if let _ = segues[indexPath.row] {
            cell?.accessoryType = .DisclosureIndicator
        }
        */
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let networkSelected = networkSelected else {
            return
        }
        guard let segue = segues[networkSelected.hashValue] else {
            self.indexSelected = nil
            return
        }
        
        self.indexSelected = indexPath
        performSegueWithIdentifier(segue, sender: tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
