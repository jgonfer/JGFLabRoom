//
//  ViewController.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    let kTagRemoveLabel = 101
    let kHeightCell: CGFloat = 55.0
    
    let headers = ["Information Access",  "Performance", "Security", "Miscellaneous", ""]
    let results = [["EventKit", "Social"], ["Grand Central Dispatch"], ["Common Crypto"], ["My Apps"], ["Clear Cache"]]
    var indexSelected: NSIndexPath?
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return results.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kHeightCell
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
        
        let title = results[indexPath.section][indexPath.row]
        if indexPath.section == 4 {
            
            // First we search in the current cell for the label
            if let view = cell!.viewWithTag(kTagRemoveLabel) {
                
                // If the label exists, we remove it before add it again
                view.removeFromSuperview()
            }
            
            // We customize our Delete Cache cell (It'll be different from the others
            let removeLabel = UILabel(frame: cell!.frame)
            removeLabel.frame.size = CGSizeMake(CGRectGetWidth(removeLabel.frame), kHeightCell)
            removeLabel.text = title
            removeLabel.textColor = UIColor.redColor()
            removeLabel.textAlignment = .Center
            removeLabel.tag = kTagRemoveLabel
            
            // Finally we add it to the cell
            cell!.addSubview(removeLabel)
            cell!.accessoryType = .None
        } else {
            cell!.textLabel!.text = title
            cell!.accessoryType = .DisclosureIndicator
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        indexSelected = indexPath
        
        let row = indexPath.row
        
        switch indexPath.section {
        case 0:
            sectionSelectedInformationAccess(row)
        case 1:
            sectionSelectedPerformance(row)
        case 2:
            sectionSelectedSecurity(row)
        case 3:
            sectionSelectedMiscellaneous(row)
        case 4:
            ImageHelper.sharedInstance.cleanCache()
        default:
            break
        }
    }
    
    
    // MARK: Sections Selection
    
    private func sectionSelectedInformationAccess(row: Int) {
        switch row {
        case 0:
            performSegueWithIdentifier(kSegueIdEventKit, sender: tableView)
        case 1:
            performSegueWithIdentifier(kSegueIdSocial, sender: tableView)
            break
        default:
            break
        }
    }

    private func sectionSelectedPerformance(row: Int) {
        switch row {
        case 0:
            performSegueWithIdentifier(kSegueIdGCD, sender: tableView)
        default:
            break
        }
    }
    
    private func sectionSelectedSecurity(row: Int) {
        switch row {
        case 0:
            performSegueWithIdentifier(kSegueIdCommonCrypto, sender: tableView)
        default:
            break
        }
    }
    
    private func sectionSelectedMiscellaneous(row: Int) {
        switch row {
        case 0:
            performSegueWithIdentifier(kSegueIdListApps, sender: tableView)
        default:
            break
        }
    }
}

