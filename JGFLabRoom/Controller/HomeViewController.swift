//
//  ViewController.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    var results = [["EventKit", "Grand Central Dispatch", "Social"], ["My Apps"]]
    var indexSelected: NSIndexPath?
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.registerStandardXibForTableView(tableView, name: "cell")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexSelected = indexSelected else {
            return
        }
        let title = results[indexSelected.section][indexSelected.row]
        let vc = segue.destinationViewController
        vc.title = title
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell!.textLabel!.text = results[indexPath.section][indexPath.row]
        cell?.accessoryType = .DisclosureIndicator
        
        //cell!.detailTextLabel!.text = "some text"
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        indexSelected = indexPath
        
        guard indexPath.section == 0 else {
            performSegueWithIdentifier(kSegueIdListApps, sender: tableView)
            return
        }
        
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier(kSegueIdEventKit, sender: tableView)
        case 1:
            performSegueWithIdentifier(kSegueIdGCD, sender: tableView)
        //case 2:
            //performSegueWithIdentifier(kSegueIdEventKit, sender: tableView)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

